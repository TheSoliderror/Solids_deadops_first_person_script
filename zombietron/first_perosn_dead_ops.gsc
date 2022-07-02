#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombietron_utility; 
init()
{
	level thread upon_player_connection(); //set up first person
	thread zombiesleft_hud(); // setup counter
}

upon_player_connection()
{
	for(;;)
	{
		level waittill("connecting", player); // looks for connecting players
		player setclientdvar("player_topDownCamMode", 0 ); //make sure to set it for joining players
		player thread intermission_monitor(player); // this makes sure when you move on to another area it keeps it first
		level waittill("round_spawning_starting"); // just in case, when zombies spawn make it first
		player setclientdvar("player_topDownCamMode", 0 ); //^^
	}
}


// ima need to use this to keep setting 1st
intermission_monitor(player)
{
	while(1)
	{
		level.in_intermission = false;
		level waittill("exit_taken");//this looks for when you exit(might not be needed)
		level.in_intermission = true;
		level waittill( "fade_in_complete"); //looks for when you when you go into a new area
		player setclientdvar("player_topDownCamMode", 0 ); //set to first in new area
	}
}

zombiesleft_hud() // zombies left function
{   
	Remaining = create_simple_hud();
  	Remaining.horzAlign = "center";
  	Remaining.vertAlign = "middle";
   	Remaining.alignX = "Left";
   	Remaining.alignY = "middle";
   	Remaining.y = 193;
   	Remaining.x = 37.5;
   	Remaining.foreground = 1;
   	Remaining.fontscale = 1.35;
   	Remaining.alpha = 1;
   	//Remaining.color = ( 0.423, 0.004, 0 );


   	ZombiesLeft = create_simple_hud();
   	ZombiesLeft.horzAlign = "center";
   	ZombiesLeft.vertAlign = "middle";
   	ZombiesLeft.alignX = "center";
   	ZombiesLeft.alignY = "middle";
   	ZombiesLeft.y = 193;
   	ZombiesLeft.x = -1;
   	ZombiesLeft.foreground = 1;
   	ZombiesLeft.fontscale = 1.35;
   	ZombiesLeft.alpha = 1;
   	//ZombiesLeft.color = ( 0.423, 0.004, 0 );
   	ZombiesLeft SetText("^1Zombies Left: ");

	while(1)
	{
		remainingZombies = get_enemy_count() + level.zombie_total;
		Remaining SetValue(remainingZombies);

		if(remainingZombies == 0 )
			{
			Remaining.alpha = 0; 
			while(1)
				{
					remainingZombies = get_enemy_count() + level.zombie_total;
					if(remainingZombies != 0 )
					{
					Remaining.alpha = 1; 
					break;
					}
					wait 0.5;
				}
			}
		wait 0.5;
	}		
}

get_enemy_count() //this is needed sense dead ops doesnt have this normaly(like wtf)
{
	enemies = [];
	valid_enemies = [];
	enemies = GetAiSpeciesArray( "axis", "all" );
	for( i = 0; i < enemies.size; i++ )
	{
		if ( is_true( enemies[i].ignore_enemy_count ) )
		{
			continue;
		}

		if( isDefined( enemies[i].animname ) )
		{
			valid_enemies = array_add( valid_enemies, enemies[i] );
		}
	}
	return valid_enemies.size;
}