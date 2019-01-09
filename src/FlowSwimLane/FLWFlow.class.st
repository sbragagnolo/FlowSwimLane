"
The flow is the reification holds the first task in the flow. 
"
Class {
	#name : #FLWFlow,
	#superclass : #Object,
	#instVars : [
		'startingTask'
	],
	#category : #'FlowSwimLane-Kernel'
}

{ #category : #visiting }
FLWFlow >> acceptVisitor: aVisitor [
	aVisitor visitFlow: self
]

{ #category : #accessing }
FLWFlow >> query [
	^ FLWFlowQuery new
		on: self;
		yourself
]

{ #category : #accessing }
FLWFlow >> startingTask [
	^ startingTask
]

{ #category : #accessing }
FLWFlow >> startingTask: aTask [
	startingTask := aTask
]
