/datum/species/elf
	name = "\improper Elf"
	id = SPECIES_ELF
	inherent_traits = list(
		TRAIT_USES_SKINTONES,
		TRAIT_TOO_TALL,
		TRAIT_EASILY_WOUNDED,
	)
	mutanteyes = /obj/item/organ/eyes/night_vision/maintenance_adapted // delete later
	mutantears = /obj/item/organ/ears/elf
	mutanttongue = /obj/item/organ/tongue/elf
	skinned_type = /obj/item/stack/sheet/animalhide/human
	species_language_holder = /datum/language_holder/elf
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1.1
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/elf, // only the head changes
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest,
	)
	var/obj/effect/dummy/lighting_obj/elf_light
	var/datum/action/innate/radiate_light/radiate_light
	var/mutable_appearance/radiate_light_effect

/datum/species/elf/Destroy(force)
	QDEL_NULL(elf_light)
	radiate_light_effect = null
	return ..()

/datum/species/elf/prepare_human_for_preview(mob/living/carbon/human/human)
	human.set_haircolor("#0f0f0b")
	human.set_hairstyle("Braid (Low)")
	human.dna.features["ears"] = "Elf"
	var/obj/item/organ/ears/elf/elf_ears = human.get_organ_by_type(/obj/item/organ/ears/elf)
	if(elf_ears)
		elf_ears.color = skintone2hex(human.skin_tone)
	human.update_body(is_creating = TRUE)

/datum/species/elf/on_species_gain(mob/living/carbon/carbon_being, datum/species/old_species, pref_load, regenerate_icons)
	if(ishuman(carbon_being))
		var/mob/living/carbon/human/elf = carbon_being
		elf.dna.features["ears"] = "Elf"
		var/obj/item/organ/ears/elf/elf_ears = new(FALSE, elf.dna.features["ears"])
		elf_ears.color = skintone2hex(elf.skin_tone)
		elf_ears.Insert(elf, movement_flags = DELETE_IF_REPLACED)

		elf_light = elf.mob_light(light_type = /obj/effect/dummy/lighting_obj/moblight/species)
		elf_light.set_light_range_power_color(3, 2, "#ffffff")
		elf_light.set_light_on(FALSE)

		radiate_light = new
		radiate_light.Grant(elf)
	return ..()

/datum/species/elf/on_species_loss(mob/living/carbon/carbon_being)
	if(radiate_light)
		radiate_light.Remove(carbon_being)
	if(radiate_light_effect)
		carbon_being.cut_overlay(radiate_light_effect)
	..()

/datum/action/innate/radiate_light
	name = "Radiate Light"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "servitude"
	button_icon = 'icons/mob/effects/genetics.dmi'
	background_icon_state = "bg_spell"
	overlay_icon_state = "bg_spell_border"

/datum/action/innate/radiate_light/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/elf = owner
	if(elf.nutrition > NUTRITION_LEVEL_STARVING || elf.stat == DEAD)
		return TRUE
	return FALSE

/datum/action/innate/radiate_light/Activate()
	var/mob/living/carbon/human/elf = owner

	if(!do_after(elf, 3 SECONDS, target = elf))
		return

	elf.visible_message(
		span_notice("[elf] starts to emit light from their body."),
		span_notice("You focus intently and light starts radiating from your body."),
	)
	active = TRUE

	var/datum/species/elf/elf_datum = elf.dna.species
	elf_datum.elf_light.set_light_on(TRUE)
	elf_datum.radiate_light_effect = mutable_appearance('icons/mob/effects/genetics.dmi', "servitude", -MUTATIONS_LAYER)
	elf.add_overlay(elf_datum.radiate_light_effect)
	playsound(elf, 'sound/effects/magic/magic_block_holy.ogg', 50, TRUE)
	START_PROCESSING(SSobj, src)
	build_all_button_icons(UPDATE_BUTTON_BACKGROUND)

/datum/action/innate/radiate_light/Deactivate()
	var/mob/living/carbon/human/elf = owner
	active = FALSE
	STOP_PROCESSING(SSobj, src)

	//var/datum/species/jelly/slime/origin_datum = H.dna.species
	var/datum/species/elf/elf_datum = elf.dna.species
	//var/obj/effect/dummy/lighting_obj/elf_light = elf.dna.species.get_light()
	elf_datum.elf_light.set_light_on(FALSE)
	elf.cut_overlay(elf_datum.radiate_light_effect)

	elf.visible_message(
		span_notice("[elf] stops emitting light from their body."),
		span_notice("Your focus fades and light stops radiating from your body."),
	)
	build_all_button_icons(UPDATE_BUTTON_BACKGROUND)

/datum/action/innate/radiate_light/process(seconds_per_tick)
	var/mob/living/carbon/human/elf = owner
	if(elf.nutrition <= NUTRITION_LEVEL_STARVING || elf.stat == DEAD)
		Deactivate()
		return

	elf.adjust_nutrition(-0.1 * seconds_per_tick)

/datum/species/elf/get_physical_attributes()
	return "A tall, thin, and frail creature similar to humans, but with pointy ears and no facial hair."

/datum/species/elf/get_species_description()
	return "Elves are intelligent humanoids dedicated to the protection of their concept of nature. \
	They are tall, thin, and frail humanoid creatures with pointy ears and no facial hair. \
	They have a heighted sense of hearing and can radiate light from their bodies to illuminate darkness."

/datum/species/elf/get_species_lore()
	return list(
		"Elven civilizations are often allies of dwarves and humans, however their conflicting view on nature \
		compared to other races, can create tension between them and their allies. Elves often prefer \
		using grown wood (and sometimes glass) for their weapons and armor, which do very little damage and offers \
		little protection respectively compared to metal.",

		"Elf ethics often differ from those of other races. Their position on moral philosophy will likely put them at \
		odds with humans, goblins, dwarves, and sometimes kobolds and animal people, although they favor war with goblins \
		over other races. At any given point in time, elves and dwarves are likely to be at peace, but it is certainly \
		possible for an elven civilization to be at war with a dwarven one.",

		"Elves value nature incredibly highly, and they also place a degree of value on family, eloquence, cunning, artwork, \
		fairness, merriment, competition, and romance, but they do not especially respect commerce and have a dislike for \
		self-control.",
	)

/datum/species/elf/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "lightbulb",
			SPECIES_PERK_NAME = "Radiate Light",
			SPECIES_PERK_DESC = "Elves have an ability to passively generate their own light at the cost of increased hunger.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_SCISSORS,
			SPECIES_PERK_NAME = "Beardless",
			SPECIES_PERK_DESC = "Clean shaven.",
		),
	)

	return to_add

