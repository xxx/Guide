
void QLevel3Init()
{
	//questL03Rat
	//lastTavernSquare
	QuestState state;
	QuestStateParseMafiaQuestProperty(state, "questL03Rat");
	
	state.quest_name = "Typical Tavern Quest";
	state.image_name = "Typical Tavern";
	state.council_quest = true;
	
	if (my_level() >= 3 && __quest_state["Level 2"].finished)
		state.startable = true;
	
	__quest_state["Level 3"] = state;
	__quest_state["Typical Tavern"] = state;
}


void QLevel3GenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!__quest_state["Level 3"].in_progress)
		return;
	QuestState base_quest_state = __quest_state["Level 3"];
	boolean wait_until_level_eleven = false;
	if (have_skill($skill[ur-kel's aria of annoyance]) && my_level() < 11)
		wait_until_level_eleven = true;
	
	ChecklistSubentry subentry;
	subentry.header = base_quest_state.quest_name;
	
    
    boolean can_skip_cold = numeric_modifier("Cold Damage") >= 20.0;
    boolean can_skip_hot = numeric_modifier("Hot Damage") >= 20.0;
    boolean can_skip_spooky = numeric_modifier("Spooky Damage") >= 20.0;
    boolean can_skip_stench = numeric_modifier("Stench Damage") >= 20.0;
    
    
	float rat_king_chance = clampNormalf(monster_level_adjustment() / 300.0);
	
    float average_tangles_found = (rat_king_chance * 8.5);
	
	if (wait_until_level_eleven)
		subentry.entries.listAppend("May want to wait until level 11 for most +ML from aria");
	string line = "Run +ML for tangles (" + roundForOutput(rat_king_chance * 100.0, 0) + "% rat king chance, " + average_tangles_found.roundForOutput(1) + " tangles on average";
	line += ")";
	
	subentry.entries.listAppend(line);
	
	string [int] elemental_sources_available;
	if ($item[piddles].available_amount() > 0 && $effect[Belch the Rainbow&trade;].have_effect() == 0)
		elemental_sources_available.listAppend("+" + MIN(11, my_level()) + " piddles");
	
	
	if (have_skill($skill[Benetton's Medley of Diversity]) && my_level() >= 15 && get_property_int("_benettonsCasts") < 10)
		elemental_sources_available.listAppend("+15 Benetton's Medley of Diversity");
	
	string elemental_sources_available_string;
	if (elemental_sources_available.count() > 0)
		elemental_sources_available_string = " (" + listJoinComponents(elemental_sources_available, ", ") + " available)";
	
    if (true)
    {
        int ncs_skippable = 0;
        string [int] additionals;
        if (!can_skip_cold)
            additionals.listAppend(HTMLGenerateSpanOfClass("cold", "r_element_cold"));
        else
            ncs_skippable += 1;
        if (!can_skip_hot)
            additionals.listAppend(HTMLGenerateSpanOfClass("hot", "r_element_hot"));
        else
            ncs_skippable += 1;
        if (!can_skip_spooky)
            additionals.listAppend(HTMLGenerateSpanOfClass("spooky", "r_element_spooky"));
        else
            ncs_skippable += 1;
        if (!can_skip_stench)
            additionals.listAppend(HTMLGenerateSpanOfClass("stench", "r_element_stench"));
        else
            ncs_skippable += 1;
        
        string line;
        if (additionals.count() > 0)
            line += "Run -combat with +20 " + additionals.listJoinComponents("/") + " damage.";
        else
            line += "Run -combat.";
        if (ncs_skippable < 4)
            line += elemental_sources_available_string;
        if (ncs_skippable > 0)
        {
            float rate = ncs_skippable.to_float() / 4.0;
            if (ncs_skippable == 4)
                line += "|Can skip every non-combat.";
            else
                line += "|Can skip " + (rate * 100.0).round() + "% of non-combats.";
        }
        if (ncs_skippable == 0)
        {
            line += "|Or possibly +combat for stats.";
            subentry.modifiers.listAppend("+combat/-combat");
        }
        else
            subentry.modifiers.listAppend("-combat");
        subentry.entries.listAppend(line);
    }
    subentry.modifiers.listAppend("+300 ML");
    
    string url = "tavern.php";
    
    if (get_property_int("lastCellarReset") == my_ascensions())
        url = "cellar.php";
	
	if (wait_until_level_eleven)
		optional_task_entries.listAppend(ChecklistEntryMake(base_quest_state.image_name, url, subentry, $locations[the typical tavern cellar]));
	else
		task_entries.listAppend(ChecklistEntryMake(base_quest_state.image_name, url, subentry, $locations[the typical tavern cellar]));
}