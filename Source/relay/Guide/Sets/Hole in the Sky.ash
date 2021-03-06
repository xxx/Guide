
boolean HITSStillRelevant()
{
	if (__misc_state["Example mode"])
		return true;
	if (!__misc_state["In run"])
		return false;
	if (__quest_state["Level 13"].state_boolean["past keys"])
		return false;
	if (!__quest_state["Level 10"].finished)
		return false;
        
	return true;
}

void QHitsGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!HITSStillRelevant())
		return;
	
	ChecklistSubentry subentry;
	subentry.header = "Hole in the Sky";
	
    string active_url = "";
    //Super unclear code. Sorry.
    
    int star_charts_needed = 0;
    int stars_needed_base = 0;
    int lines_needed_base = 0;
    
    string [int] item_names_needed;
    
	if ($item[richard's star key].available_amount() == 0)
	{
		star_charts_needed += 1;
		stars_needed_base += 8;
		lines_needed_base += 7;
		item_names_needed.listAppend($item[richard's star key]);
	}
	if ($item[star hat].available_amount() == 0)
	{
		star_charts_needed += 1;
		stars_needed_base += 5;
		lines_needed_base += 3;
		item_names_needed.listAppend($item[star hat]);
	}
	if (!have_familiar($familiar[star starfish]) && !__misc_state["familiars temporarily blocked"])
	{
		star_charts_needed += 1;
		stars_needed_base += 6;
		lines_needed_base += 4;
		item_names_needed.listAppend($item[star starfish]);
	}
    int [int] stars_needed_options;
    int [int] lines_needed_options;
    string [int] needed_options_names;
	if (__misc_state["can equip just about any weapon"])
	{
		if ($item[Star crossbow].available_amount() == 0 && $item[Star staff].available_amount() == 0 && $item[Star sword].available_amount() == 0)
		{
			star_charts_needed += 1;
			//Three paths:
			stars_needed_options.listAppend(stars_needed_base + 5);
			lines_needed_options.listAppend(lines_needed_base + 6);
			needed_options_names.listAppend("star crossbow");
			
			stars_needed_options.listAppend(stars_needed_base + 6);
			lines_needed_options.listAppend(lines_needed_base + 5);
			needed_options_names.listAppend("star staff");
			
			stars_needed_options.listAppend(stars_needed_base + 7);
			lines_needed_options.listAppend(lines_needed_base + 4);
			needed_options_names.listAppend("star sword");
			
		}
	}
	if (needed_options_names.count() == 0)
	{
		stars_needed_options.listAppend(stars_needed_base + 0);
		lines_needed_options.listAppend(lines_needed_base + 0);
	}
	
	//Convert what we need total to what's remaining:
	int star_charts_remaining = MAX(0, star_charts_needed - $item[star chart].available_amount());
    int [int] stars_remaining;
    int [int] lines_remaining;
    string [int] remaining_options_names;
    
    boolean have_met_stars_requirement = true;
    boolean have_met_lines_requirement = true;
    
    foreach key in stars_needed_options
    {
    	if (needed_options_names contains key)
	    	remaining_options_names[key] = needed_options_names[key];
    	stars_remaining[key] = MAX(0, stars_needed_options[key] - $item[star].available_amount());
    	lines_remaining[key] = MAX(0, lines_needed_options[key] - $item[line].available_amount());
    	
    	if (stars_remaining[key] > 0)
    		have_met_stars_requirement = false;
    	if (lines_remaining[key] > 0)
    		have_met_lines_requirement = false;
    }
    
    if (have_met_stars_requirement)
    {
    	//Have all stars, suggest star sword (least lines)
    	//Remove non-sword:
    	foreach key in remaining_options_names
    	{
    		if (remaining_options_names[key] != "star sword")
    		{
    			remove remaining_options_names[key];
    			remove stars_remaining[key];
    			remove lines_remaining[key];
    		}
    	}
    }
    else if (have_met_lines_requirement)
    {
    	//Have all lines, suggest star crossbow (least stars)
    	//Remove non-crossbow:
    	foreach key in remaining_options_names
    	{
    		if (remaining_options_names[key] != "star crossbow")
    		{
    			remove remaining_options_names[key];
    			remove stars_remaining[key];
    			remove lines_remaining[key];
    		}
    	}
    }
    if (remaining_options_names.count() > 0)
    {
        item_names_needed.listAppend(remaining_options_names.listJoinComponents("/", ""));
    }
	
	if (item_names_needed.count() == 0)
		return;
		
	
	if ($item[steam-powered model rocketship].available_amount() == 0)
	{
		//find a way to space:
		subentry.modifiers.listAppend("-combat");
		subentry.entries.listAppend("Run -combat on the top floor of the castle for the steam-powered model rocketship.|From steampunk non-combat, unlocks Hole in the Sky.");
        active_url = "place.php?whichplace=giantcastle";
	}
	else
	{
        active_url = "place.php?whichplace=beanstalk";
		//We've made it out to space:
		subentry.entries.listAppend("Need " + item_names_needed.listJoinComponents(", ", "and") + ".");
		
		string [int] required_components;
		if (star_charts_remaining > 0)
			required_components.listAppend(pluralize(star_charts_remaining, $item[star chart]));
		foreach key in stars_remaining
		{
			string [int] line;
			if (stars_remaining[key] > 0)
				line.listAppend(pluralize(stars_remaining[key], $item[star]));
			if (lines_remaining[key] > 0)
				line.listAppend(pluralize(lines_remaining[key], $item[line]));
			string route = "";
			if (remaining_options_names contains key)
			{
				route = " (" + remaining_options_names[key];
				if (stars_remaining.count() > 1)
					route += " route";
				route += ")";
			}
			if (line.count() > 0)
				required_components.listAppend(line.listJoinComponents(" / ") + route);
		}
		if (required_components.count() > 0)
		{
			//require more components:
			if (remaining_options_names.count() <= 1)
				subentry.entries.listAppend("Need " + required_components.listJoinComponents(", ", ""));
			else
				subentry.entries.listAppend("Need:|*" + required_components.listJoinComponents("|*", "or"));
			
			if (star_charts_remaining > 1 || (star_charts_remaining > 0 && get_property("olfactedMonster") == "Astronomer"))
			{
				subentry.entries.listAppend("Olfact astronomers");
			}
			else if (star_charts_remaining > 1) //no need for astronomers
			{
				if (my_ascensions() % 2 == 0)
					subentry.entries.listAppend("Olfact skinflute");
				else
					subentry.entries.listAppend("Olfact camel's toe");
			}
			if (!have_met_stars_requirement || !have_met_lines_requirement)
				subentry.modifiers.listAppend("+234% item");
		}
		else
			subentry.entries.listAppend("Can make everything.");
	}
	optional_task_entries.listAppend(ChecklistEntryMake("hole in the sky", active_url, subentry, $locations[the hole in the sky, the castle in the clouds in the sky (top floor)]));
}


void QHitsGenerateMissingItems(ChecklistEntry [int] items_needed_entries)
{
	if (!__misc_state["In run"] && !__misc_state["Example mode"])
		return;
	if (__quest_state["Level 13"].state_boolean["past keys"])
		return;
	//is this the best way to convey this information?
	//maybe all together instead? complicated...
	if ($item[richard's star key].available_amount() == 0)
	{
		string [int] oh_my_stars_and_gauze_garters;
		oh_my_stars_and_gauze_garters.listAppend($item[star chart].available_amount() + "/1 star chart");
		oh_my_stars_and_gauze_garters.listAppend($item[star].available_amount() + "/8 stars");
		oh_my_stars_and_gauze_garters.listAppend($item[line].available_amount() + "/7 lines");
		items_needed_entries.listAppend(ChecklistEntryMake("__item richard's star key", "", ChecklistSubentryMake("Richard's star key", "", oh_my_stars_and_gauze_garters.listJoinComponents(", ", "and"))));
	}
	
	if ($item[star hat].available_amount() == 0)
	{
		string [int] oh_my_stars_and_gauze_garters;
		oh_my_stars_and_gauze_garters.listAppend($item[star chart].available_amount() + "/1 star chart");
		oh_my_stars_and_gauze_garters.listAppend($item[star].available_amount() + "/5 stars");
		oh_my_stars_and_gauze_garters.listAppend($item[line].available_amount() + "/3 lines");
		items_needed_entries.listAppend(ChecklistEntryMake("__item star hat", "", ChecklistSubentryMake("Star hat", "", oh_my_stars_and_gauze_garters.listJoinComponents(", ", "and"))));
	}
	if ($item[star crossbow].available_amount() + $item[star staff].available_amount() + $item[star sword].available_amount() == 0)
	{
		string [int] oh_my_stars_and_gauze_garters;
		oh_my_stars_and_gauze_garters.listAppend($item[star chart].available_amount() + "/1 star chart");
		oh_my_stars_and_gauze_garters.listAppend($item[star].available_amount() + "/[5, 6, or 7] stars");
		oh_my_stars_and_gauze_garters.listAppend($item[line].available_amount() + "/[6, 5, or 4] lines");
		items_needed_entries.listAppend(ChecklistEntryMake("__item star crossbow", "", ChecklistSubentryMake("Star crossbow, staff, or sword", "", oh_my_stars_and_gauze_garters.listJoinComponents(", ", "and"))));
	}
	if (!have_familiar($familiar[star starfish]) && !__misc_state["familiars temporarily blocked"])
	{
		if ($item[star starfish].available_amount() > 0)
		{
			items_needed_entries.listAppend(ChecklistEntryMake("__item star starfish", "", ChecklistSubentryMake("Star starfish", "", "You have one, use it.")));
		}
		else
		{
			string [int] oh_my_stars_and_gauze_garters;
			oh_my_stars_and_gauze_garters.listAppend($item[star chart].available_amount() + "/1 star chart");
			oh_my_stars_and_gauze_garters.listAppend($item[star].available_amount() + "/6 stars");
			oh_my_stars_and_gauze_garters.listAppend($item[line].available_amount() + "/4 lines");
			items_needed_entries.listAppend(ChecklistEntryMake("__item star starfish", "", ChecklistSubentryMake("Star starfish", "", oh_my_stars_and_gauze_garters.listJoinComponents(", ", "and"))));
		}
	}
}