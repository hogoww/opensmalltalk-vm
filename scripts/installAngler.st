path := CommandLineArguments default commandLineArguments last.
Metacello new
  baseline: 'VMMaker';
	repository: 'tonel://' , path , '/smalltalksrc';
	load.

"Metacello new
  baseline: 'FAngler';
	repository: 'tonel://', path , '/Illicium';
	onConflictUseIncoming;
	load."