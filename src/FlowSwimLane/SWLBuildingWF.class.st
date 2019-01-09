Class {
	#name : #SWLBuildingWF,
	#superclass : #TestCase,
	#category : #'FlowSwimLane-Test'
}

{ #category : #'as yet unclassified' }
SWLBuildingWF >> swimLaneFlow [
	^ FLWExampleTestBuild new testingExample
]

{ #category : #'as yet unclassified' }
SWLBuildingWF >> swimLaneFlowToWFFlow [
	| trx |
	trx := FLWVisitingWorkflowBuilder new.  
	self swimLaneFlow acceptVisitor: trx. 
	^ trx build.
]

{ #category : #tests }
SWLBuildingWF >> testSmokeTestExampleBuilds [
	self swimLaneFlow.
]

{ #category : #tests }
SWLBuildingWF >> testSmokeTestVisiting [
	self swimLaneFlow acceptVisitor: FLWVisitingWorkflowBuilder new 
]

{ #category : #tests }
SWLBuildingWF >> testTheFlowCreatedWithVisitorIsEquivalentToTheOneUsingTheProductBuilderScript [
	| visitingCreatedFlow scriptingFlow comparingSteps comparedSteps |
	visitingCreatedFlow := self swimLaneFlowToWFFlow.
	scriptingFlow := FLWProcessWorkflow new.
	FLWContractingFlowConfigurator new doConfigureExperiment: scriptingFlow.
	self assert: scriptingFlow steps size equals: visitingCreatedFlow steps size.
	comparingSteps := scriptingFlow steps select: [ :s | s isKindOf: FLWStep ].
	comparedSteps := visitingCreatedFlow steps select: [ :t | t isKindOf: FLWStep ].
	comparingSteps do: [ :s | self assert: (comparedSteps anySatisfy: [ :s2 | s class = s2 class and: [ s task = s2 task ] ]) ]
]
