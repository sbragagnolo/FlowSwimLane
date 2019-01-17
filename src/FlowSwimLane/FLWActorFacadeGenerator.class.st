Class {
	#name : #FLWActorFacadeGenerator,
	#superclass : #Object,
	#instVars : [
		'flow'
	],
	#category : #'FlowSwimLane-Test'
}

{ #category : #'as yet unclassified' }
FLWActorFacadeGenerator >> createMethodForTask: aFLWTask [
	aFLWTask isTransformationTask
		ifTrue: [ ^ self generateTransformationTaskMethod: aFLWTask ].
	aFLWTask isCreationTask
		ifTrue: [ ^ self generateCreationTaskMethod: aFLWTask ].
	aFLWTask isFinalTask
		ifTrue: [ ^ self generateFinalTaskMethod: aFLWTask ].
	aFLWTask isConditionalTask
		ifTrue: [ ^ self generateConditionalTaskMethod: aFLWTask ].
	FLWError signal: ' Unexpected kind of task! '
]

{ #category : #creating }
FLWActorFacadeGenerator >> createTraitNamed: aName package: aPackageName [
	^ Smalltalk globals
		at: aName asSymbol
		ifPresent: [ :t | self assert: (t isTrait and: [ t package name = aPackageName ]) ]
		ifAbsent: [ Trait
				named: aName asSymbol
				uses: {}
				slots: {}
				category: aPackageName ]
]

{ #category : #'as yet unclassified' }
FLWActorFacadeGenerator >> generateActor: aFLWActor named: aTraitName inPackage: aPackageName [
	| trait methods |
	trait := self createTraitNamed: aTraitName package: aPackageName.
	methods := (flow query tasksByActor: aFLWActor) collect: [ :t | self createMethodForTask: t ].
	self install: methods onTrait: trait.
	^ trait
]

{ #category : #'as yet unclassified' }
FLWActorFacadeGenerator >> generateConditionalTaskMethod: aFLWTask [
	aFLWTask requires isEmpty
		ifTrue: [ ^ '{1}
    <task: #{2}>
	" Expected to create and return boolean "
	 self required.
'
				format:
					{aFLWTask name uncapitalized.
					aFLWTask name} ]
		ifFalse: [ ^ '{1}:a{3}
    <task: #{2}>
	" Expected to create and return a boolean "
	 self required.
'
				format:
					{aFLWTask name uncapitalized.
					aFLWTask name.
					aFLWTask requires first name} ]
]

{ #category : #'as yet unclassified' }
FLWActorFacadeGenerator >> generateCreationTaskMethod: aFLWTask [
	aFLWTask requires isEmpty
		ifTrue: [ ^ '{1}
    <task: #{3}>
	" Expected to create and return a {2} "
	 self required.
'
				format:
					{aFLWTask name uncapitalized.
					aFLWTask output name capitalized.
					aFLWTask name} ]
		ifFalse: [ ^ '{1}:a{4}
    <task: #{3}>
	" Expected to create and return a {2} "
	 self required.
'
				format:
					{aFLWTask name uncapitalized.
					aFLWTask output name capitalized.
					aFLWTask name.
					aFLWTask requires first name} ]
]

{ #category : #'as yet unclassified' }
FLWActorFacadeGenerator >> generateFinalTaskMethod: aFLWTask [
	aFLWTask requires isEmpty
		ifTrue: [ ^ '{1}
    <task: #{2}>
	 self required.
'
				format:
					{aFLWTask name uncapitalized.
					aFLWTask name} ]
		ifFalse: [ ^ '{1}:a{3}
    <task: #{2}>
	 self required.
'
				format:
					{aFLWTask name uncapitalized.
					aFLWTask name.
					aFLWTask requires first name} ]
]

{ #category : #'as yet unclassified' }
FLWActorFacadeGenerator >> generateTransformationTaskMethod: aFLWTask [ 
^ '{1}: a{2}
    <task: #{3}>
	 self required
'
				format:
					{aFLWTask name uncapitalized.
					aFLWTask output name capitalized.
					aFLWTask name}
]

{ #category : #creating }
FLWActorFacadeGenerator >> install: aCollection onTrait: aTrait [
	aCollection do: [ :m | aTrait compile: m classified: #generated ]
]

{ #category : #'as yet unclassified' }
FLWActorFacadeGenerator >> new [
	self shouldBeImplemented.
]

{ #category : #construction }
FLWActorFacadeGenerator >> on: aFLWFlow [
	flow := aFLWFlow
]
