#include "irc_bot.h"

int main(int argc, char *argv[])
{
  IrcBot bot("game_master", "Game Master");
  bot.run("127.0.0.1", 6667);
  return 0;
}
