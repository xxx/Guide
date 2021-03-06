import "relay/Guide/QuestState.ash"
import "relay/Guide/Quests.ash"
import "relay/Guide/Sets.ash"
import "relay/Guide/Pulls.ash"
import "relay/Guide/Plants.ash"

void setUpExampleState()
{
	__misc_state["In run"] = true;
    
	//Do a default reset of each quest:
	
	foreach quest_name in __quest_state
	{
		QuestState state = __quest_state[quest_name];
		
		
		QuestStateParseMafiaQuestPropertyValue(state, "started");
		
		
		__quest_state[quest_name] = state;
	}
	
	__misc_state_int["pulls available"] = 17;
}


void setUpState()
{
	__last_adventure_location = get_property_location("lastAdventure");
    
	__misc_state["In aftercore"] = get_property_boolean("kingLiberated");
	__misc_state["In run"] = !__misc_state["In aftercore"];
    if (__misc_state["Example mode"])
        __misc_state["In run"] = true;
    __misc_state["In valhalla"] = (my_class().to_string() == "Astral Spirit");
    
	if (my_turncount() >= 30 && get_property_int("singleFamiliarRun") != -1)
		__misc_state["single familiar run"] = true;
	if ($item[Clan VIP Lounge key].available_amount() > 0)
		__misc_state["VIP available"] = true;
	boolean fax_available = false;
	if (__misc_state["VIP available"])
	{
		if (!get_property_boolean("_photocopyUsed"))
			fax_available = true;
		__misc_state["fax accessible"] = true;
	}
	
	if (my_path() == "Avatar of Boris" || my_path() == "Trendy")
	{
		__misc_state["fax accessible"] = false;
	}
    if (!__misc_state["fax accessible"])
		fax_available = false;
	__misc_state["fax available"] = fax_available;
	
	
	__misc_state["can eat just about anything"] = true;
	if (my_path() == "Avatar of Jarlsberg" || my_path() == "Zombie Slayer" || fullness_limit() == 0)
	{
		__misc_state["can eat just about anything"] = false;
	}
	
	__misc_state["can drink just about anything"] = true;
	if (my_path() == "Avatar of Jarlsberg" || my_path() == "KOLHS" || inebriety_limit() == 0)
	{
		__misc_state["can eat just about anything"] = false;
	}
	
	
	__misc_state["can equip just about any weapon"] = true;
	if (my_path() == "Avatar of Boris" || my_path() == "Way of the Surprising Fist")
	{
		__misc_state["can equip just about any weapon"] = false;
	}
	
	
	__misc_state["MMJs buyable"] = false;
	if (get_property_int("lastGuildStoreOpen") == my_ascensions())
	{
		if (my_class() == $class[pastamancer] || my_class() == $class[sauceror] || (my_class() == $class[accordion thief] && my_level() >= 9))
            __misc_state["MMJs buyable"] = true;
	}
	
	//Check for moxie/mysticality/muscle combat skills:
	
	foreach s in $skills[]
	{
		if (!s.combat)
			continue;
		if (!s.have_skill())
			continue;
		if (s.class == $class[accordion thief] || s.class == $class[disco bandit])
			__misc_state["have moxie class combat skill"] = true;
		if (s.class == $class[pastamancer] || s.class == $class[sauceror])
			__misc_state["have mysticality class combat skill"] = true;
		if (s.class == $class[seal clubber] || s.class == $class[turtle tamer])
			__misc_state["have muscle class combat skill"] = true;
	}
	
	
	
	boolean yellow_ray_available = false;
	string yellow_ray_source = "";
	string yellow_ray_image_name = "";
	boolean yellow_ray_potentially_available = false;
    
    string [int] item_sources = split_string_mutable("4766,5229,6673,7013", ",");
    
    foreach key in item_sources
    {
        item source = item_sources[key].to_int().to_item();
        if (!(source.available_amount() > 0 || (source == 4766.to_item() && 4761.to_item().available_amount() > 0)))
            continue;
		yellow_ray_available = true;
		yellow_ray_source = source.to_string();
		yellow_ray_image_name = "__item " + source.to_string();
    }
    
	if (familiar_is_usable($familiar[nanorhino]) && __misc_state["have moxie class combat skill"] && get_property_int("_nanorhinoCharge") == 100)
	{
		yellow_ray_available = true;
		yellow_ray_source = "Nanorhino";
		yellow_ray_image_name = "nanorhino";
		
	}
	if (familiar_is_usable($familiar[he-boulder]))
	{
		yellow_ray_available = true;
		yellow_ray_source = "He-Boulder";
		yellow_ray_image_name = "he-boulder";
	}
	
	if (yellow_ray_available)
		yellow_ray_potentially_available = true;
	
	if (my_path() == "KOLHS")
		yellow_ray_potentially_available = true;
		
	
	if ($effect[Everything looks yellow].have_effect() > 0)
		yellow_ray_available = false;
	if (!yellow_ray_available)
		yellow_ray_source = "";
	__misc_state["yellow ray available"] = yellow_ray_available;
	__misc_state_string["yellow ray source"] = yellow_ray_source;
	__misc_state_string["yellow ray image name"] = yellow_ray_image_name;
	__misc_state["yellow ray potentially available"] = yellow_ray_potentially_available;
	
	boolean free_runs_usable = true;
	if (my_path() == "BIG!")
		free_runs_usable = false;
	__misc_state["free runs usable"] = free_runs_usable;
	
	boolean blank_outs_usable = true;
	if (my_path() == "Avatar of Jarlsberg")
		blank_outs_usable = false;
	if (!free_runs_usable)
		blank_outs_usable = false;
	__misc_state["blank outs usable"] = free_runs_usable;
	
	
	boolean free_runs_available = false;
	if (familiar_is_usable($familiar[pair of stomping boots]) || (have_skill($skill[the ode to booze]) && familiar_is_usable($familiar[Frumious Bandersnatch])))
		free_runs_available = true;
	if ($item[goto].available_amount() > 0 || $item[tattered scrap of paper].available_amount() > 0)
		free_runs_available = true;
	if ($item[greatest american pants].available_amount() > 0 || $item[navel ring of navel gazing].available_amount() > 0 || $item[peppermint parasol].available_amount() > 0)
		free_runs_available = true;
	if ($item[divine champagne popper].available_amount() > 0 || 2371.to_item().available_amount() > 0 || 7014.to_item().available_amount() > 0 || $item[handful of Smithereens].available_amount() > 0)
		free_runs_available = true;
	if ($item[V for Vivala mask].available_amount() > 0 && !get_property_boolean("_vmaskBanisherUsed"))
		free_runs_available = true;
	if (blank_outs_usable)
	{
		if ($item[bottle of Blank-Out].available_amount() > 0 || get_property_int("blankOutUsed") > 0)
			free_runs_available = true;
	}
	if (!free_runs_usable)
		free_runs_available = false;
	__misc_state["free runs available"] = free_runs_available;
	
	
	
	boolean some_olfact_available = false;
	if (have_skill($skill[Transcendent Olfaction]))
		some_olfact_available = true;
    if ($item[odor extractor].available_amount() > 0)
        some_olfact_available = true;
    if ($familiar[nosy nose].familiar_is_usable()) //weakened, but still relevantw
        some_olfact_available = true;
    if (my_path() == "Avatar of Boris" || my_path() == "Avatar of Jarlsberg" || my_path() == "Avatar of Sneaky Pete")
        some_olfact_available = true;
		
	__misc_state["have olfaction equivalent"] = some_olfact_available;
	
	
	boolean skills_temporarily_missing = false;
	boolean familiars_temporarily_blocked = false;
	boolean familiars_temporarily_missing = false;
	if (in_bad_moon())
	{
		skills_temporarily_missing = true;
		familiars_temporarily_missing = true;
	}
	if (my_path() == "Avatar of Jarlsberg" || my_path() == "Avatar of Boris")
	{
		skills_temporarily_missing = true;
		familiars_temporarily_missing = true;
		familiars_temporarily_blocked = true;
	}
	if (my_path() == "Zombie Slayer")
	{
		skills_temporarily_missing = true;
	}
	if (my_path() == "Class Act" || my_path() == "Class Act II: A Class For Pigs")
	{
		//not sure how mafia interprets "have_skill" under class act
		skills_temporarily_missing = true;
	}
	if (my_path() == "Trendy")
	{
		//not sure if this is correct
		//skills_temporarily_missing = true;
		//familiars_temporarily_missing = true;
	}
	__misc_state["skills temporarily missing"] = skills_temporarily_missing;
	__misc_state["familiars temporarily missing"] = familiars_temporarily_missing;
	__misc_state["familiars temporarily blocked"] = familiars_temporarily_blocked;
	
	
	__misc_state["AT skills available"] = true;
	if (my_path() == "Avatar of Jarlsberg" || my_path() == "Avatar of Boris" || my_path() == "Avatar of Sneaky Pete" || my_path() == "Zombie Slayer" || (my_path() == "Class Act" && my_class() != $class[accordion thief]))
		__misc_state["AT skills available"] = false;
	
	
    __misc_state_float["Non-combat statgain multiplier"] = 1.0;
	__misc_state_float["ML to mainstat multiplier"] = 1.0 / (2.0  * 4.0);
	if (my_path() == "Class Act II: A Class For Pigs")
	{
		__misc_state_float["ML to mainstat multiplier"] = 1.0 / (2.0 * 2.0);
        __misc_state_float["Non-combat statgain multiplier"] = 0.5;
		__misc_state["Stat gain from NCs reduced"] = true;
	}
	
	int pulls_available = 0;
	pulls_available = pulls_remaining();
	__misc_state_int["pulls available"] = pulls_available;
	
    //Calculate free rests available:
    int [skill] rests_granted_by_skills;
    rests_granted_by_skills[$skill[disco nap]] = 1;
    rests_granted_by_skills[$skill[adventurer of leisure]] = 2;
    rests_granted_by_skills[$skill[dog tired]] = 5;
    rests_granted_by_skills[$skill[executive narcolepsy]] = 1;
    rests_granted_by_skills[$skill[food coma]] = 10;
    
    int rests_used = get_property_int("timesRested");
    int total_rests_available = 0;
    if ($familiar[unconscious collective].have_familiar())
        total_rests_available += 3;
    
    foreach s in rests_granted_by_skills
    {
        if (s.have_skill())
            total_rests_available += rests_granted_by_skills[s];
    }
    
	__misc_state_int["free rests remaining"] = MAX(total_rests_available - rests_used, 0);
	
	//monster.monster_initiative() is usually what you need, but just in case:
	if (monster_level_adjustment() < 21)
		__misc_state_float["init ML penalty"] = 0.0;
	else if (monster_level_adjustment() < 41)
		__misc_state_float["init ML penalty"] = 0.0 + 1.0 * (monster_level_adjustment() - 20.0);
	else if (monster_level_adjustment() < 61)
		__misc_state_float["init ML penalty"] = 20.0 + 2.0 * (monster_level_adjustment() - 40.0);
	else if (monster_level_adjustment() < 81)
		__misc_state_float["init ML penalty"] = 60.0 + 3.0 * (monster_level_adjustment() - 60.0);
	else if (monster_level_adjustment() < 101)
		__misc_state_float["init ML penalty"] = 120.0 + 4.0 * (monster_level_adjustment() - 80.0);
	else
		__misc_state_float["init ML penalty"] = 200.0 + 5.0 * (monster_level_adjustment() - 100.0);
	
	
	//tower items:
	//telescope1 to telescope7
	item [string] telescope_to_item_map;
	telescope_to_item_map["an armchair"] = $item[pygmy pygment];
	telescope_to_item_map["a cowardly-looking man"] = $item[wussiness potion];
	telescope_to_item_map["a banana peel"] = $item[gremlin juice];
	telescope_to_item_map["a coiled viper"] = $item[adder bladder];
	telescope_to_item_map["a rose"] = $item[Angry Farmer candy];
	telescope_to_item_map["a glum teenager"] = $item[thin black candle];
	telescope_to_item_map["a hedgehog"] = $item[super-spiky hair gel];
	telescope_to_item_map["a raven"] = $item[Black No. 2];
	telescope_to_item_map["a smiling man smoking a pipe"] = $item[Mick's IcyVapoHotness Rub];
	telescope_to_item_map["catch a glimpse of a flaming katana"] = $item[Frigid ninja stars];
	telescope_to_item_map["catch a glimpse of a translucent wing"] = $item[Spider web];
	telescope_to_item_map["see a fancy-looking tophat"] = $item[Sonar-in-a-biscuit];
	telescope_to_item_map["see a flash of albumen"] = $item[Black pepper];
	telescope_to_item_map["see a giant white ear"] = $item[Pygmy blowgun];
	telescope_to_item_map["see a huge face made of Meat"] = $item[Meat vortex];
	telescope_to_item_map["see a large cowboy hat"] = $item[Chaos butterfly];
	telescope_to_item_map["see a periscope"] = $item[Photoprotoneutron torpedo];
	telescope_to_item_map["see a slimy eyestalk"] = $item[Fancy bath salts];
	telescope_to_item_map["see a strange shadow"] = $item[inkwell];
	telescope_to_item_map["see moonlight reflecting off of what appears to be ice"] = $item[Hair spray];
	telescope_to_item_map["see part of a tall wooden frame"] = $item[disease];
	telescope_to_item_map["see some amber waves of grain"] = $item[bronzed locust];
	telescope_to_item_map["see some long coattails"] = $item[Knob Goblin firecracker];
	telescope_to_item_map["see some pipes with steam shooting out of them"] = $item[powdered organs];
	telescope_to_item_map["see some sort of bronze figure holding a spatula"] = $item[leftovers of indeterminate origin];
	telescope_to_item_map["see the neck of a huge bass guitar"] = $item[mariachi G-string];
	telescope_to_item_map["see what appears to be the North Pole"] = $item[NG];
	telescope_to_item_map["see what looks like a writing desk"] = $item[plot hole];
	telescope_to_item_map["see the tip of a baseball bat"] = $item[baseball];
	telescope_to_item_map["see what seems to be a giant cuticle"] = $item[razor-sharp can lid];
	
	telescope_to_item_map["see a formidable stinger"] = $item[tropical orchid];
	telescope_to_item_map["see a wooden beam"] = $item[stick of dynamite];
	telescope_to_item_map["see a pair of horns"] = $item[barbed-wire fence];
	
	
	
	__misc_state_string["Gate item"] = telescope_to_item_map[get_property("telescope1")];
	__misc_state_string["Tower monster item 1"] = telescope_to_item_map[get_property("telescope2")];
	__misc_state_string["Tower monster item 2"] = telescope_to_item_map[get_property("telescope3")];
	__misc_state_string["Tower monster item 3"] = telescope_to_item_map[get_property("telescope4")];
	__misc_state_string["Tower monster item 4"] = telescope_to_item_map[get_property("telescope5")];
	__misc_state_string["Tower monster item 5"] = telescope_to_item_map[get_property("telescope6")];
	__misc_state_string["Tower monster item 6"] = telescope_to_item_map[get_property("telescope7")];
	
	if (my_path() == "Bees Hate You")
	{
		__misc_state_string["Tower monster item 1"] = "tropical orchid";
		__misc_state_string["Tower monster item 2"] = "tropical orchid";
		__misc_state_string["Tower monster item 3"] = "tropical orchid";
		__misc_state_string["Tower monster item 4"] = "tropical orchid";
		__misc_state_string["Tower monster item 5"] = "tropical orchid";
		__misc_state_string["Tower monster item 6"] = "tropical orchid";
	}
	
	int ngs_needed = 0;
	if (__misc_state_string["Tower monster item 1"] == "NG")
		ngs_needed += 1;
	if (__misc_state_string["Tower monster item 2"] == "NG")
		ngs_needed += 1;
	if (__misc_state_string["Tower monster item 3"] == "NG")
		ngs_needed += 1;
	if (__misc_state_string["Tower monster item 4"] == "NG")
		ngs_needed += 1;
	if (__misc_state_string["Tower monster item 5"] == "NG")
		ngs_needed += 1;
	if (__misc_state_string["Tower monster item 6"] == "NG")
		ngs_needed += 1;
	
	
	
	//wand
	
	boolean wand_of_nagamar_needed = true;
	if (my_path() == "Avatar of Boris" || my_path() == "Avatar of Jarlsberg" || my_path() == "Bugbear Invasion" || my_path() == "Zombie Slayer" || my_path() == "KOLHS")
		wand_of_nagamar_needed = false;
		
	int ruby_w_needed = 1;
	int metallic_a_needed = 1;
	int lowercase_n_needed = 1;
	int heavy_d_needed = 1;
	int [string] letters_needed;
	letters_needed["w"] = 1;
	letters_needed["a"] = 1;
	letters_needed["n"] = 1;
	letters_needed["d"] = 1;
	letters_needed["g"] = 0;
	
	int [string] letters_available;
	letters_available["w"] = $item[ruby w].available_amount() + $item[wa].available_amount();
	letters_available["a"] = $item[metallic a].available_amount() + $item[wa].available_amount();
	letters_available["n"] = $item[lowercase n].available_amount() + $item[nd].available_amount() + $item[ng].available_amount();
	letters_available["d"] = $item[heavy d].available_amount() + $item[nd].available_amount();
	letters_needed["n"] += ngs_needed;
	letters_needed["g"] += ngs_needed;
	
	if ($item[wand of nagamar].available_amount() > 0)
		wand_of_nagamar_needed = false;
		
		
		
	if (!wand_of_nagamar_needed)
	{
		letters_needed["w"] -= 1;
		letters_needed["a"] -= 1;
		letters_needed["n"] -= 1;
		letters_needed["d"] -= 1;
	}
	
	letters_needed["w"] = MAX(0, letters_needed["w"] - letters_available["w"]);
	letters_needed["a"] = MAX(0, letters_needed["a"] - letters_available["a"]);
	letters_needed["n"] = MAX(0, letters_needed["n"] - letters_available["n"]);
	letters_needed["d"] = MAX(0, letters_needed["d"] - letters_available["d"]);
		
	__misc_state["wand of nagamar needed"] = wand_of_nagamar_needed;
	__misc_state_int["ruby w needed"] = letters_needed["w"];
	__misc_state_int["metallic a needed"] = letters_needed["a"];
	__misc_state_int["lowercase n needed"] = letters_needed["n"];
	__misc_state_int["lowercase n available"] = letters_available["n"];
	__misc_state_int["heavy d needed"] = letters_needed["d"];
	__misc_state_int["original g needed"] = letters_needed["g"];
	
	
	int dd_tokens_and_keys_available = 0;
	int tokens_needed = 3;
	tokens_needed -= $item[fishbowl].available_amount();
	tokens_needed -= $item[fishtank].available_amount();
	tokens_needed -= $item[fish hose].available_amount();
	
	tokens_needed -= 2 * $item[hosed fishbowl].available_amount();
	tokens_needed -= 2 * $item[hosed tank].available_amount();
	
	tokens_needed -= 3 * $item[makeshift scuba gear].available_amount();
	
	tokens_needed -= $item[fat loot token].available_amount();
	tokens_needed -= $item[boris's key].available_amount();
	tokens_needed -= $item[jarlsberg's key].available_amount();
	tokens_needed -= $item[sneaky pete's key].available_amount();
	
	dd_tokens_and_keys_available += $item[fat loot token].available_amount();
	dd_tokens_and_keys_available += $item[boris's key].available_amount();
	dd_tokens_and_keys_available += $item[jarlsberg's key].available_amount();
	dd_tokens_and_keys_available += $item[sneaky pete's key].available_amount();
	
	__misc_state_int["fat loot tokens needed"] = MAX(0, tokens_needed);
	
	__misc_state_int["DD Tokens and keys available"] = dd_tokens_and_keys_available;
	
	boolean mysterious_island_unlocked = false;
	if ($items[dingy dinghy, skeletal skiff, junk junk].available_amount() > 0)
		mysterious_island_unlocked = true;
	
	__misc_state["mysterious island available"] = mysterious_island_unlocked;
	
	__misc_state["desert beach available"] = false;
	if ($items[bitchin' meatcar,desert bus pass,pumpkin carriage,tin lizzie].available_amount() > 0)
		__misc_state["desert beach available"] = true;
	if (turnsAttemptedInLocation($location[The Shore\, Inc. Travel Agency]) > 0 || turnsAttemptedInLocation($location[the arid, extra-dry desert]) > 0 || turnsAttemptedInLocation($location[the oasis]) > 0 || turnsAttemptedInLocation($location[south of the border]) > 0) //weird issues with detecting the beach. check if we've ever adventured there as a back-up
		__misc_state["desert beach available"] = true;
	
	string ballroom_song = "";
	if (get_property("lastQuartetAscension") == my_ascensions())
	{
		//1 and 3 are a guess
		if (get_property("lastQuartetRequest") == "1")
		{
			ballroom_song = "+ML";
		}
		else if (get_property("lastQuartetRequest") == "2")
		{
			ballroom_song = "-combat";
		}
		else if (get_property("lastQuartetRequest") == "3")
		{
			ballroom_song = "+item";
		}
	}
	__misc_state_string["ballroom song"] = ballroom_song;
	
	
	
	int hipster_fights_used = get_property_int("_hipsterAdv");
	if (hipster_fights_used < 0) hipster_fights_used = 0;
	if (hipster_fights_used > 7) hipster_fights_used = 7;
	
	if (familiar_is_usable($familiar[Mini-Hipster]) && !(familiar_is_usable($familiar[artistic goth kid]) && hippy_stone_broken())) //use goth kid over hipster when PVPing
	{
		__misc_state_string["hipster name"] = "hipster";
		__misc_state_int["hipster fights available"] = 7 - hipster_fights_used;
		__misc_state["have hipster"] = true;
	}
	else if (familiar_is_usable($familiar[artistic goth kid]))
	{
		__misc_state_string["hipster name"] = "goth kid";
		__misc_state_int["hipster fights available"] = 7 - hipster_fights_used;
		__misc_state["have hipster"] = true;
	}
	__misc_state_string["obtuse angel name"] = "";
	if (familiar_is_usable($familiar[reanimated reanimator]))
		__misc_state_string["obtuse angel name"] = "Reanimated Reanimator";
	else if (familiar_is_usable($familiar[obtuse angel]))
		__misc_state_string["obtuse angel name"] = "Obtuse Angel";
	
	if (get_property_int("lastPlusSignUnlock") == my_ascensions())
		__misc_state["dungeons of doom unlocked"] = true;
	else
		__misc_state["dungeons of doom unlocked"] = false;
	
	__misc_state["can use clovers"] = true;
	if (in_bad_moon() && $items[ten-leaf clover, disassembled clover].available_amount() == 0)
		__misc_state["can use clovers"] = false;
		
		
	__misc_state["bookshelf accessible"] = true;
	if (my_path() == "Zombie Slayer" || my_path() == "Avatar of Boris")
		__misc_state["bookshelf accessible"] = false;
}


void setUpQuestStateViaMafia()
{
	//Mafia's internal quest tracking system will sometimes need a quest log load to update.
	//It seems to work like this:
	//"unstarted" - quest not started
	//"started" - quest started, no progress (by log) we can see
	//"step1" - quest started, first log step completed
	//"stepX" - quest started, X steps completed
	//"finished" - quest ended
	
	QuestsInit();
	SetsInit();
	
	//Opening guild quest
	if (true)
	{
		//???
		QuestState state;
		state.startable = true;
	}
}


void finalizeSetUpState()
{
	//done after quest parsing
	
	if (__misc_state["Example mode"] || my_level() < 13 && !__misc_state["In aftercore"])
	{
		__misc_state["need to level"] = true;
	}
	
	if (__misc_state_int["pulls available"] > 0)
	{
		PullsInit();
	}
	
	finalizeSetUpFloristState();
}

void setUpQuestState()
{
    if (__misc_state["In valhalla"])
        return;
	setUpQuestStateViaMafia();
}