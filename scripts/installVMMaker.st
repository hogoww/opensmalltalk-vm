Author useAuthor: 'installVMMaker' during: [ | path defaultRemoteType|
	IceRepository registry detect:[ :r | r name = 'ovm' ]
		ifFound:[ :rep |
			rep workingCopy isDetached
				ifTrue:[ rep branch checkout ] ]
		ifNone: [
			path := CommandLineArguments default commandLineArguments nextToLast.
			defaultRemoteType := CommandLineArguments default commandLineArguments last asSymbol.

			Iceberg remoteTypeSelector: defaultRemoteType.

			Metacello new
				baseline: 'VMMaker';
				repository: 'tonel://' , path , '/smalltalksrc';
				onConflictUseIncoming;
				onDowngradeUseIncoming;
				onWarningLog;
				load.
			
			(IceRepositoryCreator new
				location: (PlatformResolver forCurrentPlatform home pathString , '/ovm/') asFileReference;
				createRepository) register.
				"Force handle creation, to be able to script it"
				(IceRepository repositories detect: [ :r | r name = 'ovm' ]) repositoryHandle.
		]
]
