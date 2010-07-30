#include "irc_bot.h"

int main(int argc, char *argv[])
{
  IrcBot bot("game_master", 
	     "Game Master",
	     "",
	     "irc.astrolink.org",
	     6667,
	     "#provola");
  
  bot.connect();
  
  return 0;
}
