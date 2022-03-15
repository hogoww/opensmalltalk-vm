Author useAuthor: 'installVMMaker' during: [ | flavour outputPath |

       MCCacheRepository disableCacheDuring: [ 
       EpMonitor disableDuring: [

       flavour := CommandLineArguments default commandLineArguments nextToLast asSymbol.
       outputPath := CommandLineArguments default commandLineArguments last asSymbol.
       [ PharoVMMaker generate: flavour outputDirectory: outputPath ]
       	 on: Error
	 do: [ Smalltalk exitFailure ].
	 Smalltalk exitSuccess
	 ]]
	 
]