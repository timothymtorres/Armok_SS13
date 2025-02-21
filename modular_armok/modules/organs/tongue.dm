/obj/item/organ/tongue/elf
	name = "elf tongue"
	liked_foodtypes = VEGETABLES | FRUIT | GRAIN
	disliked_foodtypes = GROSS | GORE | RAW | MEAT | SEAFOOD | BUGS

/obj/item/organ/tongue/elf/get_possible_languages()
	RETURN_TYPE(/list)

	return list(
		/datum/language/dwarf,
		/datum/language/elf,
	)
