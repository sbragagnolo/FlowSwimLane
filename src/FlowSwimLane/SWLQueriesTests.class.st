Class {
	#name : #SWLQueriesTests,
	#superclass : #TestCase,
	#instVars : [
		'flow',
		'query'
	],
	#category : #'FlowSwimLane-Test'
}

{ #category : #running }
SWLQueriesTests >> assertNamesOn: aCollection areIncludedIn: aCollectionOfSymbols [
	self assert: aCollection isNotEmpty.
	self assert: aCollection size equals: aCollectionOfSymbols size.
	aCollection
		do:
			[ :d | self assert: (aCollectionOfSymbols includes: d name) description: d name , ' not found ' ]
]

{ #category : #running }
SWLQueriesTests >> createTestingFlow [
	^ FLWExampleTestBuild new testingExample
]

{ #category : #'test content' }
SWLQueriesTests >> expectedDocuments [
	^ #(Contract GrantAccessReferral Invoice OrderOfService OrderOfServiceGranting PaymentNote RejectContractReferral RejectPaymentReferral)
]

{ #category : #'test content' }
SWLQueriesTests >> expectedRoles [
	^ {#ContractsManager . #PaymentsManager . #Customer . #ServiceManager}
]

{ #category : #'test content' }
SWLQueriesTests >> expectedTasks [
	^ self tasksPerActor values flatCollect: #yourself
]

{ #category : #'test content' }
SWLQueriesTests >> expectedTasksFor: aString [
	| tasks |
	tasks :=  self tasksPerActor at: aString asSymbol.
	self assert: tasks isNotEmpty .
	^ tasks 
]

{ #category : #running }
SWLQueriesTests >> setUp [
	super setUp.
	flow := self createTestingFlow.
	query := FLWFlowQuery new on: flow
]

{ #category : #'test content' }
SWLQueriesTests >> tasksPerActor [

	^ {(#ContractsManager -> #(CreateContract NoteContractReject)).
	
	   (#PaymentsManager -> #(BillCustomer IfAcceptsPayment RequireGrantAccessService RejectPayment)).
	   (#Customer  	->
			#(RequiresService IfAcceptsContract SignContract Pay NoteAccessGrant NotePaymentReject RejectsContract)).
	(#ServiceManager -> #(GrantAccess))} asDictionary
]

{ #category : #running }
SWLQueriesTests >> testDocumentsAreThoseExpected [
	^ self assertNamesOn: query documents areIncludedIn: self expectedDocuments
]

{ #category : #running }
SWLQueriesTests >> testRoleTasks [
	self assert: query roles isNotEmpty.
	query roles do: [ : role | self assertNamesOn: (query tasksByActor: role) areIncludedIn: (self expectedTasksFor: role name) ]
]

{ #category : #running }
SWLQueriesTests >> testRolesAreThoseExpected [
	^ self assertNamesOn: query roles areIncludedIn: self expectedRoles
]

{ #category : #running }
SWLQueriesTests >> testTasksAreThoseExpected [
	^ self assertNamesOn: query tasks areIncludedIn: self expectedTasks
]
