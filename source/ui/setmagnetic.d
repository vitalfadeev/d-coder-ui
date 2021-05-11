module ui.setmagnetic;

import ui;

// set childs
void set_magnetic( Element* element )
{
    set_x( element );
}


void set_x( Element* element )
{
    POS totalWidth;

    // Phase 1
    // Calculate total width
    auto powerLeft = element.inPowerLeft;
    auto powerRight = element.inPowerRight;
    size_t spaceCount;
    if ( element.firstChild !is null )
    for ( auto e = element.firstChild; e !is null; e = e.nextSibling )
    {
        totalWidth += e.computed.width;

        // ++ | --
        if ( ( powerLeft > 0 && e.powerLeft > 0 ) || ( powerLeft <= 0 && e.powerLeft <= 0 ) )
        {
            spaceCount += 1;
        }

        powerLeft = e.powerLeft;
    }

    // Last space
    // ++ | --
    if ( ( powerLeft > 0 && powerRight > 0 ) || ( powerLeft <= 0 && powerRight <= 0 ) )
    {
        spaceCount += 1;
    }


    // Phase 2
    // Set positions
    // has space insode
    if ( element.computed.width > totalWidth )
    {    
        POS totalFree = element.computed.width - totalWidth;

        POS separator;
        if ( spaceCount > 0 )
            separator =  ( totalFree / spaceCount ).to!POS;

        POS cx = element.centerX - element.computed.width / 2;

        powerLeft  = element.inPowerLeft;

        if ( element.firstChild !is null )
        for ( auto e = element.firstChild; e !is null; e = e.nextSibling )
        {
            // +- | -+
            if ( ( powerLeft > 0 && e.powerLeft <= 0 ) || ( powerLeft <= 0 && e.powerLeft > 0 ) )
            {
                e.centerX = cx + e.computed.width / 2;
                cx += e.computed.width;
            }
            else

            // ++ | --
            {
                cx += separator;
                e.centerX = cx + e.computed.width / 2;
                cx += e.computed.width;
            }

            powerLeft = e.powerLeft;
        }
    }
    else

    // no space insode
    {
        //
    }


/*
    // 3 and more
    if ( childsMore3( element ) )
    {
        // Phase 1. Calc powers
        POS  totalOffsets = 0;
        int  totalPower   = 0;
        POS  totalDistance;

        auto cmag = element.firstChild;
        auto cStan = cmag;

        POS  ofs;
        int  pwr;

        POS  cmag_m, mag_m;

        size_t cStanIdx = 0;

        // childs
        size_t i;
        if ( element.firstChild !is null )
        for ( auto mag = element.firstChild; mag !is null; mag = mag.nextSibling, i += 1 )
        {
            cmag_m = cmag.m;
            mag_m  = mag.m;

            // cmag -> mag
            // ++
            if ( cmag_m > 0 && mag_m > 0 )
            {
                pwr = cmag_m + mag_m;
                mag._cd_power  = pwr;
                mag._cd_offset = 0;
                totalPower += pwr;
            }

            else // --
            if ( cmag_m < 0 && mag_m < 0 )
            {
                pwr = abs( cmag_m + mag_m );
                mag._cd_power  = pwr;
                mag._cd_offset = 0;
                totalPower += pwr;
            }

            else // +-
            if ( cmag_m >= 0 && mag_m <= 0 )
            {
                ofs = max( cmag_m, abs( mag_m ) );
                mag._cd_power  = 0;
                mag._cd_offset = ofs;
                totalOffsets += ofs;
            }

            else // -+
            if ( cmag_m <= 0 && mag_m >= 0 )
            {
                ofs = max( abs( cmag_m ), mag_m );
                mag._cd_power  = 0;
                mag._cd_offset = ofs;
                totalOffsets += ofs;
            }

            // stan
            // Find stable magnet. Set positions.
            if ( mag.stan )
            {
                // Phase 2. Set positions
                totalDistance = mag.otd - cStan.otd - totalOffsets;

                if ( totalDistance > 0 )
                {
                    POS cmag_otd = cStan.otd;

                    // From stan to stan
                    if ( element.firstChild !is null )
                    for ( auto mag = element.firstChild; mag !is null; mag = mag.nextSibling, i += 1 )
                    {
                    foreach ( m; magnets[ cStanIdx+1 .. i+1 ] )
                    {
                        if ( m._cd_power != 0 )
                        {
                            cmag_otd += 
                                round( 
                                    ( ( cast( float ) m._cd_power ) / totalPower ) * totalDistance
                                ).to!POS;
                            m.otd = cmag_otd;
                        }
                        else
                        {
                            cmag_otd += m._cd_offset;
                            m.otd = cmag_otd;
                        }
                    }
                }

                cStan        = mag;
                cStanIdx     = i+1;
                totalOffsets = 0;
                totalPower   = 0;
            } // if stan

            cmag = mag;
        } // foreach
    }
*/
}

bool childsMore3( Element* element )
{
    if ( element.firstChild !is null && 
         element.firstChild.nextSibling !is null && 
         element.firstChild.nextSibling.nextSibling !is null )
    {
        return true;
    }

    return false;
}
