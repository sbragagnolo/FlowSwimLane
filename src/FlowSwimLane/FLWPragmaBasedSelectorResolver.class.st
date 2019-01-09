Class {
	#name : #FLWPragmaBasedSelectorResolver,
	#superclass : #Object,
	#category : #'FlowSwimLane-Query'
}

{ #category : #'as yet unclassified' }
FLWPragmaBasedSelectorResolver >> allSelectorsOn: anObject [
	| pragmas |
	pragmas := (Pragma allNamed: 'task:' from: anObject class to: ProtoObject) , (Pragma allNamed: 'task:deployment:' from: anObject class to: ProtoObject).
	^ (pragmas
		collect: [ :p | 
			FLWSelector new
				initializeWith: p;
				yourself ]) asSet 
]

{ #category : #'as yet unclassified' }
FLWPragmaBasedSelectorResolver >> flwResolveSelector: aSelector on: anObject [
	| pragmas |
	pragmas := (self allSelectorsOn: anObject) select: [ :p | p satisfy: aSelector ].
	pragmas size = 1
		ifTrue: [ ^ pragmas anyOne selector ].
	pragmas isEmpty
		ifTrue: [ ^ self error: 'There is not implementation for ' , aSelector ].
	^ self error: 'Multiple implementations for ' , aSelector
]
