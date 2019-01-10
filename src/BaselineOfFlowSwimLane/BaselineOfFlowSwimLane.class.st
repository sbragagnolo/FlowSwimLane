Class {
	#name : #BaselineOfFlowSwimLane,
	#superclass : #BaselineOf,
	#category : #BaselineOfFlowSwimLane
}

{ #category : #baselines }
BaselineOfFlowSwimLane >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: #TaskIt with: [ spec repository: 'github://sbragagnolo/taskit:dev-1.1' ];
				baseline: #RunnableWorkflow with: [ spec repository: 'github://sbragagnolo/RunnableWorkflow/src' ].
			spec package: #FlowSwimLane with: [ spec requires: #('TaskIt' RunnableWorkflow) ] ]
]
