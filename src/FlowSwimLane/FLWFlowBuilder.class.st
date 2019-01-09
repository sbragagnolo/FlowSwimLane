Class {
	#name : #FLWFlowBuilder,
	#superclass : #Object,
	#instVars : [
		'flow',
		'lastTask',
		'isLooping',
		'documents',
		'parameters',
		'tasks',
		'roles'
	],
	#category : #'FlowSwimLane-Building'
}

{ #category : #'builder selector' }
FLWFlowBuilder class >> swimLane [
	^ FLWSwimLaneFlowBuilder new
]

{ #category : #'as yet unclassified' }
FLWFlowBuilder >> addTask: aFLWTask named: aString [
	tasks
		at: aString
		ifPresent: [ ^ FLWError signal: 'There is already a task registered under the name ' , aString ]
		ifAbsent: [ aFLWTask flow: flow.
			aFLWTask name: aString.
			self registerTask: aFLWTask.
			tasks at: aString put: aFLWTask ].
	^ aFLWTask
]

{ #category : #adding }
FLWFlowBuilder >> addTaskNamed: aString [
	^ (self addTask: FLWTask new named: aString)
		beTransformationTask;
		yourself
]

{ #category : #'registering actors' }
FLWFlowBuilder >> build [
	self ensureFlowIntegrity.
	^ self internalBuild
]

{ #category : #documents }
FLWFlowBuilder >> createAndRegisterDocument: aString [
	^  documents
		at: aString
		ifPresent: [ ^ FLWError signal: 'There is already a document registered under the name ' , aString ]
		ifAbsent: [  documents
				at: aString
				put:
					(FLWDocument new
						name: aString;
						yourself) ]
]

{ #category : #parameters }
FLWFlowBuilder >> createAndRegisterParameter: aString [
	^  parameters
		at: aString
		ifPresent: [ ^ FLWError signal: 'There is already a parameter registered under the name ' , aString ]
		ifAbsent: [  parameters
				at: aString
				put:
					(FLWParameter new
						name: aString;
						yourself) ]
]

{ #category : #'registering actors' }
FLWFlowBuilder >> createAndRegisterRole: aString [
	^ roles
		at: aString
		ifPresent: [ ^ FLWError signal: 'There is already an actor registered under the name ' , aString ]
		ifAbsent: [ roles
				at: aString
				put:
					(FLWRole new
						name: aString;
						yourself) ]
]

{ #category : #accessing }
FLWFlowBuilder >> documents [
	^ documents
]

{ #category : #'registering actors' }
FLWFlowBuilder >> ensureFlowIntegrity [
	^ self ensureFlowIntegrity: flow with: Dictionary new
]

{ #category : #'registering actors' }
FLWFlowBuilder >> ensureFlowIntegrity: aFlow with: trackedDocuments [
	| task |
	task := aFlow startingTask.
	[ task hasNext ]
		whileTrue: [ task := task next.
			task flow = aFlow
				ifTrue: [ task assignedTo
						ifNil: [ ^ FLWError signal: task name , 'Task has not being assigned previous to the building' ].
					task isFinalTask
						ifTrue: [ self assert: task output isNil ].
					task isCreationTask
						ifTrue: [ self assert: task requirements size <= 1.
							trackedDocuments
								at: task output
								ifPresent: [ :t | 
									FLWError
										signal: 'The document ' , task output name , ' has been already created previously by ' , t name ]
								ifAbsent: [ trackedDocuments at: task output put: task ] ].
					task isTransformationTask
						ifTrue: [ trackedDocuments
								at: task output
								ifAbsent: [ FLWError
										signal:
											'The document ' , task output name , ' has not been created before the transformation task '
												, task name ] ].
					task isConditionalTask
						ifTrue: [ task flows do: [ :f | self ensureFlowIntegrity: f with: trackedDocuments copy ] ].
					task requirements
						select: #isDocument
						thenDo: [ :r | 
							trackedDocuments
								at: r
								ifAbsent: [ FLWError
										signal: 'The document ' , r name , ' has not been created before the transformation task ' , task name ] ] ] ]
]

{ #category : #accessing }
FLWFlowBuilder >> flow [
	^ flow
]

{ #category : #'registering actors' }
FLWFlowBuilder >> initialize [
	super initialize.
	flow := FLWFlow new.
	isLooping := false.
	parameters := Dictionary new .
	roles := Dictionary new .
	documents := Dictionary new .
	tasks := Dictionary new 
	
]

{ #category : #'registering actors' }
FLWFlowBuilder >> internalBuild [
	^ flow
]

{ #category : #'registering actors' }
FLWFlowBuilder >> isLooping [
	^ isLooping
]

{ #category : #accessing }
FLWFlowBuilder >> lastTask [
	^ lastTask ifNil: [ lastTask := flow startingTask ]
]

{ #category : #accessing }
FLWFlowBuilder >> lastTask: aFLWTask [ 
	lastTask := aFLWTask
]

{ #category : #accessing }
FLWFlowBuilder >> parameters [
	^ parameters
]

{ #category : #'task management' }
FLWFlowBuilder >> registerTask: aFLWTask [
	aFLWTask isStartingTask
		ifTrue: [ ^ aFLWTask ].
	aFLWTask flow = flow
		ifFalse: [ isLooping := true ].
	(tasks values includes: aFLWTask)
		ifTrue: [ ^ FLWError signal: 'Adding twice the same task would bring loops!' ].
	self lastTask next: aFLWTask.
	self lastTask: aFLWTask.
	^ aFLWTask
]

{ #category : #accessing }
FLWFlowBuilder >> roles [
	^ roles
]

{ #category : #accessing }
FLWFlowBuilder >> tasks [
	^ tasks
]
