void SLibramGenerateResource(ChecklistEntry [int] available_resources_entries)
{
	if (__misc_state["bookshelf accessible"])
	{
		int libram_summoned = get_property_int("libramSummons");
        int next_libram_summoned = libram_summoned + 1;
		int libram_mp_cost = MAX(1 + (next_libram_summoned * (next_libram_summoned - 1)/2) + mana_cost_modifier(), 1);
		
		
		string [int] librams_usable;
		foreach s in $skills[]
        {
			if (s.libram && s.have_skill())
				librams_usable.listAppend(s.to_string());
        }
		if (libram_mp_cost <= my_maxmp() && librams_usable.count() > 0)
		{
			ChecklistSubentry subentry;
			if (librams_usable.count() == 1)
				subentry.header = "Libram";
			else
				subentry.header = "Librams";
			subentry.header += " summonable";
			subentry.modifiers.listAppend(libram_mp_cost + "MP cost");
			
			string [int] readable_list;
			foreach key in librams_usable
			{
				string libram_name = librams_usable[key];
				if (libram_name.stringHasPrefix("Summon "))
					libram_name = libram_name.substring(7);
				readable_list.listAppend(libram_name);
			}
			
			subentry.entries.listAppend(readable_list.listJoinComponents(", ", "and") + ".");
			available_resources_entries.listAppend(ChecklistEntryMake("__item libram of divine favors", "campground.php?action=bookshelf", subentry, 7));
		}
		
		
		if (have_skill($skill[summon brickos]))
		{
			if (get_property_int("_brickoEyeSummons") <3)
			{
				ChecklistSubentry subentry;
				subentry.header =  (3 - get_property_int("_brickoEyeSummons")) + " BRICKO&trade; eye bricks obtainable";
				subentry.entries.listAppend("Cast Summon BRICKOs libram. (" + libram_mp_cost + " mp)");
				available_resources_entries.listAppend(ChecklistEntryMake("__item bricko eye brick", "campground.php?action=bookshelf", subentry, 7));
				
			}
		}
	}
	
	if (__misc_state["In run"])
	{
		boolean [item] all_possible_bricko_fights = $items[bricko eye brick,bricko airship,bricko bat,bricko cathedral,bricko elephant,bricko gargantuchicken,bricko octopus,bricko ooze,bricko oyster,bricko python,bricko turtle,bricko vacuum cleaner];
		
		int bricko_potential_fights_available = 0;
		foreach it in $items[bricko eye brick,bricko airship,bricko bat,bricko cathedral,bricko elephant,bricko gargantuchicken,bricko octopus,bricko ooze,bricko oyster,bricko python,bricko turtle,bricko vacuum cleaner]
		{
			bricko_potential_fights_available += it.available_amount();
		}
		bricko_potential_fights_available = MIN(10 - get_property_int("_brickoFights"), bricko_potential_fights_available);
		if (bricko_potential_fights_available > 0)
		{
			ChecklistSubentry subentry;
			subentry.header =  bricko_potential_fights_available + " BRICKO&trade; fights ready";
			
			
			foreach fight in all_possible_bricko_fights
			{
				int number_available = fight.available_amount();
				if (number_available > 0)
					subentry.entries.listAppend(pluralize(number_available, fight));
			}
			
			item [int] craftable_fights;
			string [int] creatable;
			foreach fight in all_possible_bricko_fights
			{
                monster m = fight.to_string().to_monster(); //is there a better way to look this up?
				int bricks_needed = get_ingredients(fight)[$item[bricko brick]];
				int monster_level = m.raw_attack;
				int number_available = creatable_amount(fight);
				if (number_available > 0)
				{
					craftable_fights.listAppend(fight);
					creatable.listAppend(pluralize(number_available, fight) + " (" + bricks_needed + " bricks, " + monster_level + "ML)");
				}
			}
			
			if (creatable.count() > 0)
				subentry.entries.listAppend("Creatable: (" + $item[bricko brick].available_amount() + " bricks available)" + HTMLGenerateIndentedText(creatable));
				
			available_resources_entries.listAppend(ChecklistEntryMake("__item bricko brick", "inventory.php?which=3", subentry, 7));
		}
	}
}