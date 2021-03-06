

void SDispensaryGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	//Not sure how I feel about this. The dispensary is very useful, but not necessary to complete an ascension.
	if (dispensary_available())
		return;
	if (!__misc_state["can equip just about any weapon"]) //need to wear KGE to learn the password
		return;
	
	if (!__quest_state["Level 5"].started || !locationAvailable($location[cobb's knob barracks]))
		return;
	
	ChecklistSubentry subentry;
	subentry.header = "Unlock Cobb's Knob Dispensary";
	
	string [int] dispensary_advantages;
	if (!black_market_available() && !__misc_state["MMJs buyable"])
		dispensary_advantages.listAppend("MP Restorative");
	dispensary_advantages.listAppend("+30% meat");
	dispensary_advantages.listAppend("+15% items");
	if (my_path() != "Bees Hate You" && !__misc_state["familiars temporarily blocked"])
		dispensary_advantages.listAppend("+5 familiar weight");
	dispensary_advantages.listAppend("+1 mainstat/fight");
	
	if (dispensary_advantages.count() > 0)
		subentry.entries.listAppend("Access to " + dispensary_advantages.listJoinComponents(", ", "and") + " buff items");
		
	if ($item[Cobb's Knob lab key].available_amount() == 0)
		subentry.entries.listAppend("Find the cobb's knob lab key either laying around, or defeat the goblin king.");
	else
	{
		if (have_outfit_components("Knob Goblin Elite Guard Uniform"))
		{
			if (!is_wearing_outfit("Knob Goblin Elite Guard Uniform"))
				subentry.entries.listAppend("Wear KGE outfit, adventure in Cobb's Knob Barracks.");
			else
				subentry.entries.listAppend("Adventure in Cobb's Knob Barracks.");
		}
		else
			subentry.entries.listAppend("Acquire KGE outfit");
	}
	optional_task_entries.listAppend(ChecklistEntryMake("__half Dispensary", "cobbsknob.php", subentry, 10));
}