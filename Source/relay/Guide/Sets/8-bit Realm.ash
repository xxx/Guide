

void S8bitRealmGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	int total_white_pixels = $item[white pixel].available_amount() + creatable_amount($item[white pixel]);
	if (__quest_state["Level 13"].state_boolean["digital key used"] || (total_white_pixels >= 30 || $item[digital key].available_amount() > 0))
        return;
    boolean need_route_output = true;
    //Need white pixels for digital key.
    if (familiar_is_usable($familiar[angry jung man]) && $item[psychoanalytic jar].available_amount() == 0 && $item[jar of psychoses (The Crackpot Mystic)].available_amount() == 0 && !get_property_boolean("_psychoJarUsed"))
    {
        //They have a jung man, but haven't acquired a jar yet.
        ChecklistSubentry subentry;
    
        string url = "";
        if (my_familiar() != $familiar[angry jung man])
            url = "familiar.php";
        int jung_mans_charge_turns_remaining = 1 + (30 - MIN(30, get_property_int("jungCharge")));

        subentry.header = "Bring along the angry jung man";
    
        subentry.entries.listAppend(pluralize(jung_mans_charge_turns_remaining, "turn", "turns") + " until jar drops. (skip 8-bit realm)");
    
        optional_task_entries.listAppend(ChecklistEntryMake("__familiar angry jung man", url, subentry));
        need_route_output = false;
    }
    if ($item[psychoanalytic jar].available_amount() > 0 || $item[jar of psychoses (The Crackpot Mystic)].available_amount() > 0 || get_property_boolean("_psychoJarUsed")) //FIXME check which jar used
    {
        string active_url = "";
        //Have a jar, or jar was installed.
        string [int] description;
        string [int] modifiers;
        
        if (get_property_boolean("_psychoJarUsed"))
        {
            active_url = "place.php?whichplace=junggate_3";
            modifiers.listAppend("+150% item");
            modifiers.listAppend("olfact morbid skull");
            description.listAppend("Run +150% item, olfact morbid skull.");
            description.listAppend(total_white_pixels + "/30 white pixels found.");
        }
        else if ($item[jar of psychoses (The Crackpot Mystic)].available_amount() > 0)
        {
            active_url = "inventory.php?which=3";
            description.listAppend("Open the " + $item[jar of psychoses (The Crackpot Mystic)] + ".");
        }
        else if ($item[psychoanalytic jar].available_amount() > 0)
        {
            active_url = "place.php?whichplace=forestvillage";
            description.listAppend("Psychoanalyze the crackpot mystic.");
        }
        optional_task_entries.listAppend(ChecklistEntryMake("__item digital key", active_url, ChecklistSubentryMake("Adventure in fear man's level", modifiers, description), $locations[fear man's level]));
        need_route_output = false;
    }
    if (need_route_output)
    {
        if (in_hardcore())
        {
            string [int] description;
            string [int] modifiers;
            modifiers.listAppend("olfact bloopers");
            modifiers.listAppend("+67% item");
            
            description.listAppend("Run +67% item, olfact bloopers.");
            description.listAppend(total_white_pixels + "/30 white pixels found.");
            if (__misc_state["VIP available"] && __misc_state["fax accessible"])
                description.listAppend("Possibly consider faxing/copying a ghost. (+150% item, drops five white pixels)");
            //No other choice. 8-bit realm.
            //Well, I suppose they could fax and arrow a ghost.
            if ($item[continuum transfunctioner].available_amount() > 0)
                optional_task_entries.listAppend(ChecklistEntryMake("inexplicable door", "", ChecklistSubentryMake("Adventure in the 8-bit realm", "", description), $locations[8-bit realm]));
            else if (my_level() >= 2)
                optional_task_entries.listAppend(ChecklistEntryMake("__item continuum transfunctioner", "", ChecklistSubentryMake("Acquire a continuum transfunctioner", "", "From the crackpot mystic.")));
        }
        else
        {
            //softcore, suggest pulling a jar of psychoses.
            optional_task_entries.listAppend(ChecklistEntryMake("__item psychoanalytic jar", "", ChecklistSubentryMake("Pull a jar of psychoses (The Crackpot Mystic)", "", "To make digital key.")));
        }
    }
}