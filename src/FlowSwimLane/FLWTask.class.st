"
A normal task defines a general behaviour for sequential behaviour. 
Each task is defined and configured in terms of the contribution to the system in terms of Documents: 

- Creates a document
- Transform a document 
- Final state (the document finishes there) It finishes the flow, meaning that it does not create any new document.

"
Class {
	#name : #FLWTask,
	#superclass : #FLWInbetweenTask,
	#instVars : [
		'flowTask',
		'isFinalTask',
		'next',
		'output',
		'isStartingTask'
	],
	#category : #'FlowSwimLane-Kernel'
}

{ #category : #visiting }
FLWTask >> acceptVisitor: aVisitor [
	aVisitor visitTask: self
]

{ #category : #setting }
FLWTask >> beCreationTask [
	flowTask := FLWCreationRequestStep
]

{ #category : #setting }
FLWTask >> beFinalTask [
	flowTask := FLWNoResultRequestStep.
	isFinalTask := true
]

{ #category : #accessing }
FLWTask >> beStartingTask [
	isStartingTask := true.
	name := #StartingTask. 
	self beCreationTask
]

{ #category : #setting }
FLWTask >> beTransformationTask [
	flowTask := FLWTransformingRequestStep
]

{ #category : #setting }
FLWTask >> creates: aFLWDocument [
	self beCreationTask.
	output := aFLWDocument
]

{ #category : #accessing }
FLWTask >> flowTask [
	^ flowTask
]

{ #category : #accessing }
FLWTask >> hasNext [
	^ next isNotNil
]

{ #category : #accessing }
FLWTask >> initialize [
	super initialize.
	isFinalTask := false.
	isStartingTask := false
]

{ #category : #testing }
FLWTask >> isCreationTask [
	^ flowTask = FLWCreationRequestStep
]

{ #category : #accessing }
FLWTask >> isFinalTask [
	^ isFinalTask
]

{ #category : #accessing }
FLWTask >> isStartingTask [
	^ isStartingTask
]

{ #category : #accessing }
FLWTask >> isTransformationTask [
	^ flowTask = FLWTransformingRequestStep
]

{ #category : #accessing }
FLWTask >> next [
	^ next
]

{ #category : #accessing }
FLWTask >> next: aFLWTask [ 
	next := aFLWTask
]

{ #category : #accessing }
FLWTask >> output [
	^ self provides first
]

{ #category : #'as yet unclassified' }
FLWTask >> transforms: aFLWDocument [
	self beTransformationTask.
	output := aFLWDocument
]
