"
This test ensure the creation restriction of a flow. 
Specific tasks have specific restrictions. 
The flows are suppsed to manage unique names. 
Finally, the user must have a way to define what kind of task it is. 
"
Class {
	#name : #SWLCreationTest,
	#superclass : #TestCase,
	#instVars : [
		'flow',
		'builder',
		'document'
	],
	#category : #'FlowSwimLane-Test'
}

{ #category : #'test task' }
SWLCreationTest >> testABuilderDeniesTasksWithoutAssignement [
	builder := FLWFlowBuilder swimLane.
	document := builder createAndRegisterDocument: #Order.
	(builder addTaskNamed: #CreationTask)
		creates: document;
		yourself.
	self should: [ builder build ] raise: FLWError.
]

{ #category : #'test task' }
SWLCreationTest >> testACreationTaskCannotCreateAnAreadyCreatedDocument [
	| actor |
	builder := FLWFlowBuilder swimLane.
	document := builder createAndRegisterDocument: #Order.
	actor := builder createAndRegisterRole: #Actor.
	(builder addTaskNamed: #CreationTask)
		creates: document;
		assignedTo: actor;
		yourself.
	(builder addTaskNamed: #CreationTask2)
		creates: document;
		assignedTo: actor;
		yourself.
	self should: [ builder build ] raise: FLWError
]

{ #category : #'test task' }
SWLCreationTest >> testACreationTaskIsConfigurable [
	| task actor |
	builder := FLWFlowBuilder swimLane.
	document := builder createAndRegisterDocument: #Order.
	actor := builder createAndRegisterRole: #Actor.
	task := (builder addTaskNamed: #CreationTask)
		creates: document;
		assignedTo: actor;
		yourself.
	builder build.
	self assert: task isCreationTask
]

{ #category : #'test task' }
SWLCreationTest >> testACreationTaskIsConfigurableAndAssignable [
	| task actor |
	builder := FLWFlowBuilder swimLane.
	document := builder createAndRegisterDocument: #Order.
	actor := builder createAndRegisterRole: #Actor.
	task := (builder addTaskNamed: #CreationTask)
		creates: document;
		assignedTo: actor;
		yourself.
	builder build.
	self assert: task isCreationTask
]

{ #category : #'test task' }
SWLCreationTest >> testACreationTaskMayRequireDocuments [
	| task actor document2 |
	builder := FLWFlowBuilder swimLane.
	document := builder createAndRegisterDocument: #Doc.
	document2 := builder createAndRegisterDocument: #Doc2.
	actor := builder createAndRegisterRole: #Actor.
	(builder addTaskNamed: #CreationTask)
		creates: document;
		assignedTo: actor;
		yourself.
	(builder addTaskNamed: #CreationTask2)
		creates: document2;
		assignedTo: actor;
		yourself.
	task := (builder addTaskNamed: #Tx2)
		requires: document;
		transforms: document2;
		assignedTo: actor;
		yourself.
	builder build.
	self assert: task isTransformationTask.
	self assert: (task requirements includes: document).
	self assert: task requirements size equals: 1
]

{ #category : #'test task' }
SWLCreationTest >> testACreationTaskMayRequireParameters [
	| task actor parameter |
	builder := FLWFlowBuilder swimLane.
	document := builder createAndRegisterDocument: #Doc.
	parameter := builder createAndRegisterParameter: #Parameter.
	actor := builder createAndRegisterRole: #Actor.
	task := (builder addTaskNamed: #CreationTask)
		creates: document;
		requires: parameter;
		assignedTo: actor;
		yourself.
	builder build.
	self assert: task isCreationTask .
	self assert: (task requirements includes: parameter)
]

{ #category : #'test task' }
SWLCreationTest >> testACreationTaskWithRequiredDocumentsMustbeCreatedBefore [
	| task actor document2 |
	builder := FLWFlowBuilder swimLane.
	document := builder createAndRegisterDocument: #Doc.
	document2 := builder createAndRegisterDocument: #Doc2.
	actor := builder createAndRegisterRole: #Actor.
	(builder addTaskNamed: #CreationTask)
		creates: document;
		assignedTo: actor;
		yourself.
	task := (builder addTaskNamed: #Tx2)
		requires: document2;
		transforms: document;
		assignedTo: actor;
		yourself.
	self should: [ builder build ] raise: FLWError
]

{ #category : #'test task' }
SWLCreationTest >> testATransformationTaskNeedsAnExistantDocument [
	| actor |
	builder := FLWFlowBuilder swimLane.
	document := builder createAndRegisterDocument: #Order.
	actor := builder createAndRegisterRole: #Actor.
	(builder addTaskNamed: #TransformationTask)
		transforms: document;
		assignedTo: actor;
		yourself.
	self should: [ builder build ] raise: FLWError
]

{ #category : #'test task' }
SWLCreationTest >> testATransformationTaskNeedsAnExistantDocumentBuildsProperly [
	| actor |
	builder := FLWFlowBuilder swimLane.
	actor := builder createAndRegisterRole: #Actor.
	document := builder createAndRegisterDocument: #Order.
	(builder addTaskNamed: #CreationTask)
		creates: document;
		assignedTo: actor;
		yourself.
	(builder addTaskNamed: #TransformationTask)
		transforms: document;
		assignedTo: actor;
		yourself.
	flow := builder build.
	self assert: flow startingTask next isCreationTask.
	self assert: flow startingTask next next isTransformationTask
]

{ #category : #'test task' }
SWLCreationTest >> testConditionalLoopsAreAllowed [
	| task conditional |
	builder := FLWFlowBuilder swimLane.
	task := builder addTaskNamed: #One.
	conditional := builder addConditionalTaskNamed: #IfCondition ifTrue: [ :ifTrue | ifTrue registerTask: task ] ifFalse: [ :ifFalse |  ].
	self assert: conditional truePath startingTask next equals: task
]

{ #category : #'test task' }
SWLCreationTest >> testConditionalLoopsAreAllowedInFalseBrancheAlso [
	| task conditional |
	builder := FLWFlowBuilder swimLane.
	task := builder addTaskNamed: #One.
	conditional := builder
		addConditionalTaskNamed: #IfCondition
		ifTrue: [ :ifTrue |  ]
		ifFalse: [ :ifFalse | ifFalse registerTask: task ].
	self assert: conditional falsePath startingTask next equals: task
]

{ #category : #'test task' }
SWLCreationTest >> testConditionalLoopsAreNotAllowedInBothBranches [
	| task1 task2 conditional |
	builder := FLWFlowBuilder swimLane.
	task1 := builder addTaskNamed: #One.
	task2 := builder addTaskNamed: #Two.
	self
		should: [ conditional := builder
				addConditionalTaskNamed: #IfCondition
				ifTrue: [ :ifTrue | ifTrue registerTask: task1 ]
				ifFalse: [ :ifFalse | ifFalse registerTask: task2 ] ]
		raise: FLWError
]

{ #category : #'tests actor' }
SWLCreationTest >> testCreateAndRegisterActorFailsIfDuplicated [
	builder := FLWFlowBuilder swimLane.
	builder createAndRegisterRole: #Actor.
	self should: [ builder createAndRegisterRole: #Actor ] raise: FLWError
]

{ #category : #'tests actor' }
SWLCreationTest >> testCreatedActorAndGettedActorAreIdentical [
	| actor |
	builder := FLWFlowBuilder swimLane.
	actor := builder createAndRegisterRole: #Actor.
	(builder addTaskNamed: #Test)
		beFinalTask;
		assignedTo: actor.
	flow := builder build.
	self assert: actor identicalTo: (flow query findActorFor: #Actor)
]

{ #category : #'test task types' }
SWLCreationTest >> testCreationTaskCanBecomeFinalTask [
	| task  |
	builder := FLWFlowBuilder swimLane.
	task := builder addTaskNamed: #One.
	task beCreationTask.
	task beFinalTask.
	self deny: task isTransformationTask. 
	self assert: task isFinalTask.
]

{ #category : #'test task types' }
SWLCreationTest >> testCreationTaskCanBecomeTransformationTask [
	| task |
	builder := FLWFlowBuilder swimLane.
	task := builder addTaskNamed: #One.
	task beCreationTask.
	task beTransformationTask.
	self assert: task isTransformationTask.

]

{ #category : #'test task types' }
SWLCreationTest >> testDefaultAddTaskAddsTransformationTask [
	| task  |
	builder := FLWFlowBuilder swimLane.
	task := builder addTaskNamed: #One.
	self assert: task isTransformationTask. 
]

{ #category : #'test task types' }
SWLCreationTest >> testDefaultTaskCanBecomeCreationTask [ 
	| task  |
	builder := FLWFlowBuilder swimLane.
	task := builder addTaskNamed: #One.
	task beCreationTask.
	self deny: task isTransformationTask. 
	self assert: task isCreationTask.
]

{ #category : #'test task types' }
SWLCreationTest >> testDefaultTaskCanBecomeFinalTask [
	| task  |
	builder := FLWFlowBuilder swimLane.
	task := builder addTaskNamed: #One.
	task beFinalTask.
	self deny: task isTransformationTask. 
	self assert: task isFinalTask.
]

{ #category : #'test documents' }
SWLCreationTest >> testDefineDocumentCreatesAnEmptyDocumentDescription [
	| document |
	builder := FLWFlowBuilder swimLane.
	document := builder createAndRegisterDocument: #Order.
	self assert: document isEmpty
]

{ #category : #'test task' }
SWLCreationTest >> testFlowAlwaysAddTasksInTheEnd [
	builder := FLWFlowBuilder swimLane.
	builder addTaskNamed: #JustAfterStart.
	flow := builder flow.
	self assert: builder tasks size equals: 1.
	self assert: flow  startingTask next equals: (flow query findTaskNamed: #JustAfterStart)
]

{ #category : #'test task' }
SWLCreationTest >> testInconditionalLoopsAreForbidden [
	| task |
	builder := FLWFlowBuilder swimLane.
	task := builder addTaskNamed: #Task.
	self should: [ builder registerTask: task ] raise: FLWError
]

{ #category : #'test task' }
SWLCreationTest >> testMultipleConditionalLoopsAreForbidden [
	| task |
	builder := FLWFlowBuilder swimLane.
	task := builder addTaskNamed: #Task.
	self
		should: [ builder
				addSwitchTaskNamed: #IfCondition
				conditions: [ :switch | 
					switch
						case: #value then: [ :aFlow | aFlow registerTask: task ];
						case: #value then: [ :aFlow |  ];
						otherwise: [ :aFlow |  ] ] ]
		raise: FLWError
]

{ #category : #'test task' }
SWLCreationTest >> testMultipleConditionalTaskAllowsTwoPathsWithTheABuilder [
	| conditionalFlows |
	builder := FLWFlowBuilder swimLane.
	conditionalFlows := OrderedCollection new.
	builder
		addSwitchTaskNamed: #IfCondition
		conditions: [ :switch | 
			switch
				case: #value then: [ :aFlow | conditionalFlows add: (aFlow isKindOf: FLWFlowBuilder) ];
				case: #value then: [ :aFlow | conditionalFlows add: (aFlow isKindOf: FLWFlowBuilder) ];
				otherwise: [ :aFlow | conditionalFlows add: (aFlow isKindOf: FLWFlowBuilder) ] ].
	self assert: conditionalFlows size equals: 3.
	self assert: (conditionalFlows allSatisfy: #yourself)
]

{ #category : #'test task' }
SWLCreationTest >> testMultipleConditionalTaskIsTheEndOfThisFlow [
	| task1 task2 conditional |
	builder := FLWFlowBuilder swimLane.
	task1 := builder addTaskNamed: #One.
	task2 := builder addTaskNamed: #Two.
	conditional := builder
		addSwitchTaskNamed: #IfCondition
		conditions: [ :switch | 
			switch
				case: #value then: [ :aFlow |  ];
				case: #value then: [ :aFlow |  ];
				otherwise: [ :aFlow |  ] ].
	self assert: task1 hasNext.
	self assert: task2 hasNext.
	self deny: conditional hasNext
]

{ #category : #'test task' }
SWLCreationTest >> testMultipleConditionalTaskIsTheEndOfThisFlowSoItGivesErrorOnAdd [
	builder := FLWFlowBuilder swimLane.
	builder addTaskNamed: #One.
	builder addTaskNamed: #Two.
	builder
		addSwitchTaskNamed: #IfCondition
		conditions: [ :switch | 
			switch
				case: #value then: [ :aFlow |  ];
				case: #value then: [ :aFlow |  ];
				otherwise: [ :aFlow |  ] ].
	self should: [ builder addTaskNamed: #three ] raise: FLWError
]

{ #category : #'tests flow' }
SWLCreationTest >> testNewSWLFlowContainsAStartTask [
	flow := FLWFlowBuilder swimLane build.
	self assert: flow startingTask isStartingTask 
]

{ #category : #'test task' }
SWLCreationTest >> testOnErrorFlow [
	<expectedFailure>
	| handler |
	builder := FLWFlowBuilder swimLane.
	handler := builder createAndRegisterRole: #ErrorHandler.
	self flag: #reviewThisApi.
	builder
		addOnErrorFlow: [ :errorFlowBuilder | 
			(errorFlowBuilder
				addConditionalTaskNamed: #IfHandleError
				ifTrue: [ :ifTrue | (ifTrue addTaskNamed: #ManageError) assignedTo: handler ]
				ifFalse: [ :ifFalse | 
					(ifFalse addTaskNamed: #EndWithError)
						beFinalTask;
						assignedTo: handler ]) assignedTo: handler ]
]

{ #category : #'tests actor' }
SWLCreationTest >> testRegisteringActorAddsAnActor [
	builder := FLWFlowBuilder swimLane.
	builder createAndRegisterRole: #Actor.
	flow := builder build.
	self assert: builder roles size equals: 1
]

{ #category : #'test task' }
SWLCreationTest >> testSimpleConditionalTaskAllowsTwoPathsWithTheABuilder [
	| ifTrueIsABuilder ifFalseIsABuilder |
	builder := FLWFlowBuilder swimLane.
	builder addConditionalTaskNamed: #IfCondition ifTrue: [ :ifTrue | ifTrueIsABuilder := ifTrue isKindOf: FLWFlowBuilder ] ifFalse: [ :ifFalse | ifFalseIsABuilder := ifFalse isKindOf: FLWFlowBuilder ].
	self assert: ifTrueIsABuilder.
	self assert: ifFalseIsABuilder
]

{ #category : #'test task' }
SWLCreationTest >> testSimpleConditionalTaskIsTheEndOfThisFlow [
	| task1 task2 conditional |
	builder := FLWFlowBuilder swimLane.
	task1 := builder addTaskNamed: #One.
	task2 := builder addTaskNamed: #Two.
	conditional := builder addConditionalTaskNamed: #IfCondition ifTrue: [ :ifTrue |  ] ifFalse: [ :ifFalse |  ].
	self assert: task1 hasNext.
	self assert: task2 hasNext.
	self deny: conditional hasNext
]

{ #category : #'test task' }
SWLCreationTest >> testSimpleConditionalTaskIsTheEndOfThisFlowSoItGivesErrorOnAdd [
	builder := FLWFlowBuilder swimLane.
	builder addTaskNamed: #One.
	builder addTaskNamed: #Two.
	builder addConditionalTaskNamed: #IfCondition ifTrue: [ :ifTrue |  ] ifFalse: [ :ifFalse |  ].
	self should: [ builder addTaskNamed: #three ] raise: FLWError
]

{ #category : #'test task' }
SWLCreationTest >> testTheAddTaskFailsIfThereIsDuplicate [
	builder := FLWFlowBuilder swimLane.
	builder addTaskNamed: #JustAfterStart.
	self should: [ builder addTaskNamed: #JustAfterStart ] raise: FLWError
]

{ #category : #'test task' }
SWLCreationTest >> testTheCreatedTaskIsTheSameAsTheQueried [
	| task |
	builder := FLWFlowBuilder swimLane.
	task := builder addTaskNamed: #JustAfterStart.
	flow := builder flow.
	self assert: task identicalTo: (flow query findTaskNamed: #JustAfterStart)
]

{ #category : #'tests actor' }
SWLCreationTest >> testThereIsNotActorByDefault [
	flow := FLWFlowBuilder swimLane build.
	self assert: flow query roles isEmpty
]
