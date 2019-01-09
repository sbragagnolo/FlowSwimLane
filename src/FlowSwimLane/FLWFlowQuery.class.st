Class {
	#name : #FLWFlowQuery,
	#superclass : #Object,
	#instVars : [
		'flow'
	],
	#category : #'FlowSwimLane-Query'
}

{ #category : #query }
FLWFlowQuery >> documents [
	^ self flattener documents 
]

{ #category : #query }
FLWFlowQuery >> findActorFor: aString [ 
	^ self flattener roles detect: [ :t | t name = aString ]
]

{ #category : #query }
FLWFlowQuery >> findTaskNamed: aString [
	^ self flattener tasks detect: [ :t | t name = aString ]
]

{ #category : #query }
FLWFlowQuery >> flattener [
	| flattener |
	flattener := FLWFlowQueryTaskFlattener new.
	flow acceptVisitor: flattener.
	^ flattener
]

{ #category : #initializing }
FLWFlowQuery >> on: aFLWFlow [ 
	flow := aFLWFlow
]

{ #category : #query }
FLWFlowQuery >> parameters [ 
	^ self flattener parameters
]

{ #category : #query }
FLWFlowQuery >> roles [
	^ self flattener roles  
]

{ #category : #query }
FLWFlowQuery >> tasks [
	^ self flattener tasks
]

{ #category : #query }
FLWFlowQuery >> tasksByActor: aFLWActor [
	^ self tasks select: [ :t | t assignedTo = aFLWActor ]
]
