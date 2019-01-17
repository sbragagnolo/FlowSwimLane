"
This builder is a visitor that creates a WfWorkflow, based on the Flow's flow reification 
"
Class {
	#name : #FLWVisitingWorkflowBuilder,
	#superclass : #Object,
	#instVars : [
		'builder'
	],
	#category : #'FlowSwimLane-WF'
}

{ #category : #accessing }
FLWVisitingWorkflowBuilder >> build [
	^ builder build 
]

{ #category : #accessing }
FLWVisitingWorkflowBuilder >> builder: aBLCProductAwareFlowBuilder [
	builder := aBLCProductAwareFlowBuilder
]

{ #category : #initialization }
FLWVisitingWorkflowBuilder >> initialize [
	| workflow |
	workflow := FLWProcessWorkflow new.
	builder := FLWProductAwareProcessWorkflowBuilder on: workflow
]

{ #category : #visiting }
FLWVisitingWorkflowBuilder >> visitConditionalTask: aFLWConditionalTask [
	self assert: aFLWConditionalTask requires size = 1.
	builder
		then: aFLWConditionalTask assignedTo name
		with: aFLWConditionalTask requires first name
		decides: aFLWConditionalTask name
		ifTrue: [ :ifTrue | 
			| sub |
			sub := self class new.
			sub builder: ifTrue.
			aFLWConditionalTask truePath acceptVisitor: sub ]
		ifFalse: [ :ifFalse | 
			| sub |
			sub := self class new.
			sub builder: ifFalse.
			aFLWConditionalTask falsePath acceptVisitor: sub ]
]

{ #category : #accessing }
FLWVisitingWorkflowBuilder >> visitFlow: aFLWFlow [
	aFLWFlow startingTask acceptVisitor: self
]

{ #category : #visiting }
FLWVisitingWorkflowBuilder >> visitTask: aFLWTask [
	| step |
	aFLWTask isStartingTask 
		ifFalse: [ " Not yet generalized "
			self assert: aFLWTask requires size < 2.
			step := builder newStepOfClass: aFLWTask flowTask.
			step responsible: aFLWTask assignedTo name.
			aFLWTask requires isEmpty
				ifTrue: [ aFLWTask isFinalTask
						ifFalse: [ step input: aFLWTask output name ] ]
				ifFalse: [ step input: aFLWTask requires first name ].
			step task: aFLWTask name.
			aFLWTask isFinalTask
				ifFalse: [ step output: aFLWTask output name ].
			builder addStep: step ].
	aFLWTask hasNext
		ifTrue: [ aFLWTask next acceptVisitor: self ]
]
