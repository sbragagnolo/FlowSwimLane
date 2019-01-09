"
An Abstract Task implements the general idea of a task in a Flow. 
It acknowledges the existance of a next task,  the need of requirements for being applyied and the relationship with a Responsible Role 
    
requires:           a,b
                     v 
                 [ Task ]   -next->   [ Task ]
                     ^ 
responsible:      manager 
"
Class {
	#name : #FLWAbstractTask,
	#superclass : #Object,
	#instVars : [
		'name',
		'flow',
		'assignedTo',
		'requires'
	],
	#category : #'FlowSwimLane-Kernel'
}

{ #category : #accessing }
FLWAbstractTask >> assignedTo [
	^ assignedTo
]

{ #category : #accessing }
FLWAbstractTask >> assignedTo: aFLWActor [
	assignedTo := aFLWActor
]

{ #category : #flow }
FLWAbstractTask >> flow [
	^ flow
]

{ #category : #accessin }
FLWAbstractTask >> flow: aFLWFlow [
	flow := aFLWFlow
]

{ #category : #testing }
FLWAbstractTask >> hasNext [
	^ self subclassResponsibility
]

{ #category : #flow }
FLWAbstractTask >> initialize [
	super initialize.
	requires := OrderedCollection new
]

{ #category : #flow }
FLWAbstractTask >> isConditionalTask [
	^ false
]

{ #category : #testing }
FLWAbstractTask >> isCreationTask [
	^ false
]

{ #category : #testing }
FLWAbstractTask >> isFinalTask [
	^ false
]

{ #category : #testing }
FLWAbstractTask >> isStartingTask [
	^ false
]

{ #category : #testing }
FLWAbstractTask >> isTransformationTask [
	^ false
]

{ #category : #testing }
FLWAbstractTask >> name [
	^ name
]

{ #category : #testing }
FLWAbstractTask >> name: aString [
	name := aString
]

{ #category : #accessing }
FLWAbstractTask >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: name;
		nextPut: $)
]

{ #category : #accessing }
FLWAbstractTask >> requirements [
	^ requires 
]

{ #category : #accessing }
FLWAbstractTask >> requires [
	^ requires
]

{ #category : #accessing }
FLWAbstractTask >> requires: aFLWDocumentOrParameter [

	requires add: aFLWDocumentOrParameter
]
