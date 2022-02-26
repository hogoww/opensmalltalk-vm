Author useAuthor: 'installVMMaker' during: [ | flavour outputPath |
       flavour := CommandLineArguments default commandLineArguments nextToLast asSymbol.
       outputPath := CommandLineArguments default commandLineArguments last asSymbol.
       [ PharoVMMaker generate: flavour outputDirectory: outputPath ]
       	 on: Exception do: [ Smalltalk exitFailure ]
]