Class {
	#name : #FLWSwimLaneFlowBuilder,
	#superclass : #FLWFlowBuilder,
	#category : #'FlowSwimLane-Building'
}

{ #category : #'task building' }
FLWSwimLaneFlowBuilder >> addConditionalTaskNamed: aString ifTrue: ifTrueBuildingBlock ifFalse: ifFalseBuildingBlock [
	| conditional ifTrueBuilder ifFalseBuilder |
	conditional := FLWConditionalTask new.
	self addTask: conditional named: aString.
	ifTrueBuilder := self class new.
	ifTrueBuildingBlock value: ifTrueBuilder.
	ifFalseBuilder := self class new.
	ifFalseBuildingBlock value: ifFalseBuilder.
	(ifTrueBuilder isLooping and: [ ifFalseBuilder isLooping ])
		ifTrue: [ ^ FLWError signal: 'Only one branch can be used for looping at the time' ].
	conditional truePath: ifTrueBuilder internalBuild.
	conditional falsePath: ifFalseBuilder internalBuild.
	^ conditional
]

{ #category : #'multi conditional task' }
FLWSwimLaneFlowBuilder >> addSwitchTaskNamed: aTaskName conditions: aConditionsBuilderClosure [
	| conditional cases |
	conditional := FLWMultiConditionalTask new.
	self addTask: conditional named: aTaskName.
	cases := FLWMultiConditionalTaskFlowBuilder new.
	cases flowBuilder: self class .
	aConditionsBuilderClosure value: cases.
	conditional cases: cases build.
	^ conditional
]

{ #category : #'registering actors' }
FLWSwimLaneFlowBuilder >> initialize [
	super initialize.
	flow
		startingTask:
			(FLWTask new
				beStartingTask;
				yourself)
]
