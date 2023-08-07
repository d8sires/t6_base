getPlayerName(player)
{
    playerName = getSubStr(player.name, 0, player.name.size);
    for(i=0; i < playerName.size; i++)
    {
        if(playerName[i] == "]")
            break;
    }
    if(playerName.size != i)
        playerName = getSubStr(playerName, i + 1, playerName.size);
    return playerName;
}

vector_scale(vec,scale)
{
    vec =(vec[0] * scale,vec[1] * scale,vec[2] * scale);
    return vec;
}

placeholder()
{
    self iprintln("@d8sires");
}

teletohim( player )
{
    self iprintlnbold( "Teleported to ^5" + player.name );
    self setorigin( player.origin + ( -10, 0, 0 ) );
}

teletome( player )
{
    self iprintlnbold( "^5" + ( player.name + " ^7Teleported to you!" ) );
    player setorigin( self.origin + ( -10, 0, 0 ) );
}