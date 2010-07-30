#include "irc_bot.h"

int main(int argc, char *argv[])
{
  IrcBot bot("game_master", 
	     "Game Master",
	     "",
	     "irc.azzurra.org",
	     6667,
	     "#casd");
  
  bot.connect();
  
  return 0;
}
