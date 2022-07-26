#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombietron_utility; 
init()
{
	thread onConnect(); //set up first person
	thread zombiesleft_hud(); // setup counter
}

onConnect()
{
	for(;;)
	{
		level waittill( "connecting", player );
		player thread fps_tron();
	}
}

fps_tron() //will always be fps no matter what
{
	for(;;)
	{
		players = GetPlayers();	
		for(i = 0; i < players.size; i ++)
		{
			players[i] setclientdvar("player_topDownCamMode", 0 );
		}
		wait 0.05;
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
