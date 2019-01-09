Class {
	#name : #FLWFlowQueryTaskFlattener,
	#superclass : #Object,
	#instVars : [
		'tasks',
		'actors',
		'parameters',
		'documents'
	],
	#category : #'FlowSwimLane-Query'
}

{ #category : #accessing }
FLWFlowQueryTaskFlattener >> documents [
	^ documents asSet 
]

{ #category : #initialization }
FLWFlowQueryTaskFlattener >> initialize [
	super initialize.
	tasks := OrderedCollection new.
	actors := OrderedCollection new.
	documents := OrderedCollection new .
	parameters := OrderedCollection new .
]

{ #category : #accessing }
FLWFlowQueryTaskFlattener >> parameters [
	^ parameters asSet
]

{ #category : #accessing }
FLWFlowQueryTaskFlattener >> roles [
	^ actors asSet 
]

{ #category : #accessing }
FLWFlowQueryTaskFlattener >> tasks [
	^ tasks asSet 
]

{ #category : #accessing }
FLWFlowQueryTaskFlattener >> visitActor: aFLWActor [
	actors add: aFLWActor
]

{ #category : #accessing }
FLWFlowQueryTaskFlattener >> visitConditionalTask: aFLWConditionalTask [ 
	tasks add: aFLWConditionalTask .
	aFLWConditionalTask requires do:[ : a | a acceptVisitor: self  ].
	aFLWConditionalTask assignedTo acceptVisitor: self.
	aFLWConditionalTask truePath acceptVisitor: self .
	aFLWConditionalTask falsePath acceptVisitor: self .
]

{ #category : #visiting }
FLWFlowQueryTaskFlattener >> visitDocuments: aFLWDocument [ 
	documents add: aFLWDocument 
]

{ #category : #visiting }
FLWFlowQueryTaskFlattener >> visitFlow: aFLWFlow [
	aFLWFlow startingTask next ifNotNil: [ :t | t acceptVisitor: self ]
]

{ #category : #visiting }
FLWFlowQueryTaskFlattener >> visitParameter: aFLWParameter [
	parameters add: aFLWParameter
]

{ #category : #visiting }
FLWFlowQueryTaskFlattener >> visitTask: aFLWTask [
	tasks add: aFLWTask.
	aFLWTask assignedTo ifNotNil: [ :o | o acceptVisitor: self ].
	aFLWTask output ifNotNil: [ :o | o acceptVisitor: self ].
	aFLWTask requires do: [ :a | a acceptVisitor: self ].
	aFLWTask hasNext
		ifTrue: [ aFLWTask next acceptVisitor: self ]
]
