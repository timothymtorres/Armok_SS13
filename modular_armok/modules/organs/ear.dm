/datum/sprite_accessory/ears/elf
	icon = 'modular_armok/modules/species/icons/elf_ears.dmi'
	em_block = TRUE
	name = "Elf"
	icon_state = "elf"
	//color_src = HAIR_COLOR

/obj/item/organ/ears/elf
	name = "elf ears"
	visual = TRUE
	damage_multiplier = 2
	//preference = "feature_human_ears"
	organ_traits = list(TRAIT_GOOD_HEARING)
	dna_block = DNA_EARS_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/elf_ears

/// Bodypart overlay for the elf ears
/datum/bodypart_overlay/mutant/elf_ears
	layers = EXTERNAL_FRONT | EXTERNAL_BEHIND
	feature_key = "ears"
	/// Layer upon which we add the inner ears overlay
	var/inner_layer = EXTERNAL_FRONT

/datum/bodypart_overlay/mutant/elf_ears/get_global_feature_list()
	return SSaccessories.ears_list

/datum/bodypart_overlay/mutant/elf_ears/can_draw_on_bodypart(mob/living/carbon/human/human)
	if((human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return FALSE
	return TRUE

/datum/bodypart_overlay/mutant/elf_ears/get_image(image_layer, obj/item/bodypart/limb)
	var/mutable_appearance/base_ears = ..()

	// Only add inner ears on the inner layer
	if(image_layer != bitflag_to_layer(inner_layer))
		return base_ears

	// Construct image of inner ears, apply to base ears as an overlay
	feature_key += "inner"
	var/mutable_appearance/inner_ears = ..()
	inner_ears.appearance_flags = RESET_COLOR
	feature_key = initial(feature_key)

	base_ears.overlays += inner_ears
	return base_ears
