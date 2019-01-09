Class {
	#name : #SWLRoleGenerationTest,
	#superclass : #TestCase,
	#instVars : [
		'flow',
		'generator'
	],
	#category : #'FlowSwimLane-Test'
}

{ #category : #asserting }
SWLRoleGenerationTest >> assert: aFLWTask isManagedBy: aMethod [
	| selectors |
	selectors := aMethod pragmas
		select: [ :p | p selector = #task: or: [ p selector = #task:deployment: ] ]
		thenCollect: [ :p | FLWSelector new initializeWith: p ].

	^ selectors anySatisfy: [ :s | aFLWTask name = s task and: [ s deployment = #default ] ]
]

{ #category : #tests }
SWLRoleGenerationTest >> generatingCategory [
	^ '__BYLGeneratedCode'	
]

{ #category : #tests }
SWLRoleGenerationTest >> setUp [
	super setUp.
	flow := FLWExampleTestBuild new testingExample.
	generator := FLWActorFacadeGenerator new
		on: flow;
		yourself.
	
]

{ #category : #tests }
SWLRoleGenerationTest >> tearDown [
	(self generatingCategory asPackageIfAbsent: [ nil ]) ifNotNil: [ :package | package removeFromSystem ]
]

{ #category : #tests }
SWLRoleGenerationTest >> testBasicControllerGeneratorForActorCreatesRoleTrait [
	| trait |
	self assert: (Smalltalk at: #GeneratedCustmerActor ifAbsent: [ nil ]) isNil.
	trait := generator
		generateActor: (flow query roles detect: [ :actor | actor name = #Customer ])
		named: #GeneratedCustmerActor
		inPackage: self generatingCategory.
	self assert: (Smalltalk at: #GeneratedCustmerActor ifAbsent: [ nil ]) equals: trait.
	
]

{ #category : #tests }
SWLRoleGenerationTest >> testBasicControllerGeneratorForActorCreatesRoleTraitWithExepectedContent [
	| trait customer |
	customer := flow query roles detect: [ :actor | actor name = #Customer ].
	trait := generator generateActor: customer named: #GeneratedCustmerActor inPackage: self generatingCategory.
	(flow query tasksByActor: customer) do: [ :task | self assert: (trait methods anySatisfy: [ :m | self assert: task isManagedBy: m ]) ]
]

{ #category : #tests }
SWLRoleGenerationTest >> testBasicControllerGeneratorForActorCreatesRoleTraitWithSameAmount [
	| trait customer |
	customer := flow query roles detect: [ :actor | actor name = #Customer ].
	trait := generator generateActor: customer named: #GeneratedCustmerActor inPackage: self generatingCategory.
	self assert: trait methods size equals: (flow query tasksByActor: customer) size
]
