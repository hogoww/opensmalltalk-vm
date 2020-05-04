iceRep := IceRepository registry detect:[ :aRep| aRep name = #Illicium ].
iceRep branch pullFrom: iceRep remotes first.
iceRep branch checkout.