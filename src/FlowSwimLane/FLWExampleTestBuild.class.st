Class {
	#name : #FLWExampleTestBuild,
	#superclass : #Object,
	#instVars : [
		'builder',
		'customerData',
		'orderOfService',
		'customer',
		'contract',
		'invoice',
		'paymentNote',
		'orderOfServiceGranting',
		'serviceManager',
		'grantAccessReferral',
		'rejectPaymentReferral',
		'rejectContractReferral',
		'contractManager',
		'paymentManager'
	],
	#category : #'FlowSwimLane-Test'
}

{ #category : #accessing }
FLWExampleTestBuild >> contract [
		^ contract ifNil: [  contract := builder createAndRegisterDocument: #Contract ]
]

{ #category : #accessing }
FLWExampleTestBuild >> contractManager [
	^ contractManager
		ifNil: [ contractManager := builder createAndRegisterRole: #ContractManager ]
]

{ #category : #accessing }
FLWExampleTestBuild >> customer [
	^ customer ifNil: [  customer := builder createAndRegisterRole: #Customer ]
]

{ #category : #accessing }
FLWExampleTestBuild >> customerData [
	^ customerData ifNil: [ customerData := builder createAndRegisterParameter: #CustomerData ]
]

{ #category : #accessing }
FLWExampleTestBuild >> grantAccessReferral [
	^ grantAccessReferral
		ifNil: [ grantAccessReferral := builder createAndRegisterDocument: #GrantAccessReferral ]
]

{ #category : #'registering actors' }
FLWExampleTestBuild >> initialize [
	super initialize.
	builder := FLWFlowBuilder swimLane
]

{ #category : #accessing }
FLWExampleTestBuild >> invoice [
	^ invoice ifNil: [ invoice := builder createAndRegisterDocument: #Invoice ]
]

{ #category : #accessing }
FLWExampleTestBuild >> orderOfService [
	^ orderOfService ifNil: [ orderOfService := builder createAndRegisterDocument: #OrderOfService ]
]

{ #category : #accessing }
FLWExampleTestBuild >> orderOfServiceGranting [
	^ orderOfServiceGranting
		ifNil: [ orderOfServiceGranting := builder createAndRegisterDocument: #OrderOfServiceGranting ]
]

{ #category : #accessing }
FLWExampleTestBuild >> paymentManager [
	^ paymentManager
		ifNil: [ paymentManager := builder createAndRegisterRole: #PaymentManager ]
]

{ #category : #accessing }
FLWExampleTestBuild >> paymentNote [
	^ paymentNote ifNil: [ paymentNote := builder createAndRegisterDocument: #PaymentNote ]
]

{ #category : #accessing }
FLWExampleTestBuild >> rejectContractReferral [
	^ rejectContractReferral
		ifNil: [ rejectContractReferral := builder createAndRegisterDocument: #RejectContractReferral ]
]

{ #category : #accessing }
FLWExampleTestBuild >> rejectPaymentReferral [
	^ rejectPaymentReferral
		ifNil: [ rejectPaymentReferral := builder createAndRegisterDocument: #RejectPaymentReferral ]
]

{ #category : #accessing }
FLWExampleTestBuild >> serviceManager [
	^ serviceManager ifNil: [ serviceManager := builder createAndRegisterRole: #ServiceManager ]
]

{ #category : #'registering actors' }
FLWExampleTestBuild >> testingExample [

	(builder addTaskNamed: #RequiresService)
		requires: self customerData;
		creates: self orderOfService;
		assignedTo: self customer.
	(builder addTaskNamed: #CreateContract)
		requires: self orderOfService;
		creates: self contract;
		assignedTo: self contractManager.
	(builder
		addConditionalTaskNamed: #IfAcceptsContract
		ifTrue: [ :ifAcceptsContract | 
					(ifAcceptsContract addTaskNamed: #SignContract)
						transforms: self contract;
						assignedTo: self customer.
					(ifAcceptsContract addTaskNamed: #BillCustomer)
						requires: self contract;
						creates: self invoice;
						assignedTo: self paymentManager.
					(ifAcceptsContract addTaskNamed: #Pay)
						requires: self invoice;
						creates: self paymentNote;
						assignedTo: self customer.
					(ifAcceptsContract
						addConditionalTaskNamed: #IfAcceptsPayment
						ifTrue: [ :ifAcceptsPayment | 
									(ifAcceptsPayment addTaskNamed: #RequireGrantAccessService)
										requires: self paymentNote;
										assignedTo: self paymentManager;
										creates: self orderOfServiceGranting.
									(ifAcceptsPayment addTaskNamed: #GrantAccess)
										requires: self orderOfServiceGranting;
										assignedTo: self serviceManager;
										creates: self grantAccessReferral.
									(ifAcceptsPayment addTaskNamed: #NoteAccessGrant)
										requires: self grantAccessReferral;
										assignedTo: self customer;
										beFinalTask 
						]
						ifFalse: [ :ifRejectsPayment | 
										(ifRejectsPayment addTaskNamed: #RejectPayment)
											requires: self paymentNote;
											assignedTo: self paymentManager;
											creates: self rejectPaymentReferral.
										(ifRejectsPayment addTaskNamed: #NotePaymentReject)
											requires: self rejectPaymentReferral;
											assignedTo: self customer;
											beFinalTask ]) 	requires: self paymentNote; assignedTo: self paymentManager 
						]
		ifFalse: [ : ifRejectsContract | 
			
						(ifRejectsContract addTaskNamed: #RejectsContract)
							requires: self contract;
							assignedTo: self customer;
							creates: self rejectContractReferral.
						(ifRejectsContract addTaskNamed: #NoteContractReject)
							requires: self rejectContractReferral;
							assignedTo: self contractManager;
							beFinalTask .
			
		]) 	requires: self contract; assignedTo: self customer.
		
	^ builder build
]
