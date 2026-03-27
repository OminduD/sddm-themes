import os

font_mapping = {
    "blind_dragon.conf": "Mamoru",
    "boy_and_dragon.conf": "Toragon",
    "dragon_bride.conf": "Ryujin",
    "dragons_gaze.conf": "Shinrinyoku",
    "japanese_spring.conf": "Sakura Town",
    "samurai_spirit.conf": "Ninja Kage",
    "samurai_tree.conf": "Hachimaki",
    "under_cherry_tree.conf": "Mistuki",
    "yae_miko_among_the_sakura.conf": "Tokyo Noir",
    "zi_ling_a_mortals_journey_to_immortality.conf": "Ming Imperial",
    "crimson_moon.conf": "Wasabi",
    "dawn_wanderer.conf": "Asian Scroll",
    "golden_hour.conf": "Sukajan Brush",
    "moonlight_seascape.conf": "Osake",
    "mountain_horizon.conf": "Art of Japanese Calligraphy",
    "torn_mask.conf": "Ujiro",
    "tranquil_lake.conf": "Kogoro",
    "cloud_castle.conf": "Qakong",
    "majestic_peaks.conf": "Qaoquin",
    "fantasy_flute.conf": "Geza Script",
    "digital_shadows.conf": "Terminus",
    "nebula_black_hole.conf": "Perfect DOS VGA 437",
    "vi_and_powder.conf": "Silkscreen",
    "2b_midnight_bloom.conf": "VT323",
    "yae_miko_pixel_art2.conf": "Press Start 2P",
    "evening_drive.conf": "Pixel Emulator",
    "shadowblade_wanderer.conf": "Monocraft",
    "before_the_road.conf": "Minecraftia",
    "autumn_cat.conf": "Fusion Pixel",
    "evelyn.conf": "Qashion",
    "landscape_sea_ships.conf": "Uciharo",
    "rocks_glow_with_autumn_fire.conf": "Qadhaong",
    "serenity.conf": "Sushi Fusion",
    "sunset_train.conf": "Zapanese Font Duo",
    "green_fields_and_peaks.conf": "Goatskin Brush"
}

directory = "Themes"
updated_count = 0

for filename, font_name in font_mapping.items():
    filepath = os.path.join(directory, filename)
    if os.path.exists(filepath):
        with open(filepath, 'r') as file:
            lines = file.readlines()
        
        with open(filepath, 'w') as file:
            for line in lines:
                if line.startswith('Font='):
                    file.write(f'Font="{font_name}"\n')
                else:
                    file.write(line)
        updated_count += 1
        print(f"Updated {filename} -> {font_name}")

print(f"\\nSuccessfully updated {updated_count} themes.")
