path := CommandLineArguments default commandLineArguments last.
Metacello new
  baseline: 'VMMaker';
	repository: 'tonel://' , path , '/smalltalksrc';
	load.

Metacello new
  repository: 'github://hogoww/Illicium:StateTranslator';
  baseline: 'FAngler';
  onConflictUseIncoming;
  load.
