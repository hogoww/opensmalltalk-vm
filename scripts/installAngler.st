path := CommandLineArguments default commandLineArguments last.
Metacello new
  baseline: 'VMMaker';
	repository: 'tonel://' , path , '/smalltalksrc';
	load.

Metacello new
  baseline: 'FAngler';
	repository: 'github://hogoww/Illicium:StateTranslator';
	onConflictUseIncoming;
	load.
