/datum/species/dwarf
	name = "\improper Dwarf"
	id = SPECIES_DWARF
	inherent_traits = list(
		TRAIT_USES_SKINTONES,
		TRAIT_DWARF,
		TRAIT_ALCOHOL_TOLERANCE,
		TRAIT_HEAVY_DRINKER,
		TRAIT_NIGHT_VISION,
	)
	skinned_type = /obj/item/stack/sheet/animalhide/human
	species_language_holder = /datum/language_holder/dwarf
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1.1

/datum/species/dwarf/prepare_human_for_preview(mob/living/carbon/human/human)
	human.set_haircolor("#0f0f0b")
	human.set_hairstyle("Braid (Low)")
	human.set_facial_hairstyle("Beard (Dwarf)")
	human.set_facial_haircolor("#251d10")
	human.update_body(is_creating = TRUE)

/datum/species/dwarf/get_physical_attributes()
	return "A short, sturdy creature fond of drink and industry."

/datum/species/dwarf/get_species_description()
	return "They are well known for their stout physique and prominent beards (on the males), \
	which begin to grow from birth; dwarves are stronger, shorter, stockier, and hairier than the average human, \
	have a heightened sense of their surroundings and possess perfect darkvision."

/datum/species/dwarf/get_species_lore()
	return list(
		"Dwarven civilizations typically form (mostly) peaceful, trade-based relationships with humans and elves, \
		but are bitter enemies with goblins, and consider kobolds a petty annoyance. Dwarven babies become children \
		one year after birth, grow up to become adults at their eighteenth birthday, and live to be around 150-170 years of age.",

		"Dwarves live both in elaborate underground fortresses carved from the mountainside and above-ground hillocks, \
		are naturally gifted miners, metalsmiths, and stone crafters, and value the acquisition of wealth and rare \
		metals above all else.",
	)

/datum/species/dwarf/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_MOON,
			SPECIES_PERK_NAME = "Night Vision",
			SPECIES_PERK_DESC = "Dwarves can see slightly more clearly in full darkness.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_BEER,
			SPECIES_PERK_NAME = "Alcholic",
			SPECIES_PERK_DESC = "Dwarves just can't live without alcohol. \
				They become drunk more slowly and suffer fewer drawbacks from alcohol.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_BASEBALL,
			SPECIES_PERK_NAME = "Weak Throw",
			SPECIES_PERK_DESC = "Dwarves are small and short, this severely reduces their throwing ability.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_HORSE,
			SPECIES_PERK_NAME = "Mount Restrictions",
			SPECIES_PERK_DESC = "Due to their short legs, dwarves are unable to properly ride animals with mounts.",
		),
	)

	return to_add

