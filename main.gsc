#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes/_hud_util;
init() 
{
    //credits to: @xeirh for coding help, functions, and other additions!!! :)
    level thread connect();
    PrecacheModel("mp_flag_neutral");
    precachemodel("script_model");
    precachemodel("collision_clip_32x32x10");
	precacheshader("line_horizontal");
	precacheshader("black");
    level.strings = [];
    level.title   = "Menu Base";
    level.creator = "d8sires";
    level.permission = strTok("None;Access;Admin;Host;Dev", ";");
    level.shaders = array( "menu_mp_contract_expired", "menu_mp_killstreak_select", "ui_scrollbar_arrow_up_a", "ui_scrollbar_arrow_dwn_a", "ui_arrow_left", "ui_arrow_right", "gradient_fadein" );
    for( a = 0; a < level.shaders.size; a++ ) {
        precacheshader( level.shaders[ a ] );
    }
    if( !isdefined( level.overflowfix ) ) {
        level.overflowfix = true;
        level thread overflowfix();
    }
}

connect()
{
    self endon("disconnect");
    while(true)
    {
        level waittill("connecting", player);
        player thread spawned();
        if(player ishost())
            player.access = ( ( player ishost( ) ) ? level.permission[ level.permission.size - 1 ] : level.permission [ level.permission.size - 2 ] );
        else
            player.access = level.permission[ 0 ];
    }
}

spawned()
{
    self endon("disconnect");
    level endon("game_ended");
    self waittill("spawned_player");
    if( !isdefined( self.menu_access ) && self get_access() ) {
        self.menu_access = true;
        self thread init_menu();
    }
    self freezeControls(false);
}

init_menu() {
    self endon( "disconnect" );
    level endon( "end_game" );

    self.desires           = [];
    self.desires[ "menu" ] = "Welcome " + get_player( self );
    self.menu               = spawnstruct();
    self.menu.current_menu  = self.desires[ "menu" ];

    self init_preload();
    self menu_option();
    while( true ) {
        if( !isdefined( self.menu.open ) ) {
            if( self adsbuttonpressed() && self ActionSlotOneButtonPressed() ) {
                self open_menu();
                wait .15;
            }
        }
        else {
            if( self useButtonPressed() ) {
                menu = self get_menu();
                if( isdefined( self.menu.previous[ menu ] ) ) {
                    self new_menu( self.menu.previous[ menu ] );
                }
                else {
                    self close_menu();
                }
                wait .15;
            }
            if( self ActionSlotOneButtonPressed() || self ActionSlotTwoButtonPressed() ) {
                menu = self get_menu();
                if( !self ActionSlotOneButtonPressed() || !self ActionSlotTwoButtonPressed() ) {
                    self.menu.cursor[ menu ] += self ActionSlotTwoButtonPressed();
                    self.menu.cursor[ menu ] -= self ActionSlotOneButtonPressed();
                    if( self.menu.option[ menu ].size >= 2 || !self.menu.option[ menu ].size <= 0 ) {
                    }
                    self update_scroller();
                    self update_utilities();
                    wait .125;
                }
            }
            if( self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed() ) {
                menu   = self get_menu();
                cursor = self get_cursor();
                if( isdefined( self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] ) ) {
                    self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] += self actionslotthreebuttonpressed();
                    self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] -= self actionslotfourbuttonpressed();
                    if( self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] < 0 ) {
                        self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] = self.menu.slider[ menu ][ "array" ][ cursor ].size - 1;
                    }
                    if( self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] > self.menu.slider[ menu ][ "array" ][ cursor ].size - 1 ) {
                        self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] = 0;
                    }
                    if( self.menu.slider[ menu ][ "array" ][ cursor ].size >= 2 ) {
                    }
                    self.menu.slider[ menu ][ "slider" ][ cursor ] = self.menu.slider[ menu ][ "array" ][ cursor ][ self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] ];
                    self update_slider( self.menu.slider[ menu ][ "slider" ][ cursor ] );
                    wait .125;
                }
            }
            if( self JumpButtonPressed() ) {
                menu   = self get_menu();
                cursor = self get_cursor();
                if( isdefined( self.menu.slider[ menu ][ "slider" ][ cursor ] ) ) {
                    self thread [[ self.menu.function[ menu ][ cursor ] ]]( self.menu.slider[ menu ][ "slider" ][ cursor ], self.menu.input_a[ menu ][ cursor ], self.menu.input_b[ menu ][ cursor ], self.menu.input_c[ menu ][ cursor ], self.menu.input_d[ menu ][ cursor ], self.menu.input_e[ menu ][ cursor ] );
                }
                else {
                    self thread [[ self.menu.function[ menu ][ cursor ] ]]( self.menu.input_a[ menu ][ cursor ], self.menu.input_b[ menu ][ cursor ], self.menu.input_c[ menu ][ cursor ], self.menu.input_d[ menu ][ cursor ], self.menu.input_e[ menu ][ cursor ] );
                }
                wait .25;
            }
        }
        wait .05;
    }
}