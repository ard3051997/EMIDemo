import os
import urllib.request
import json

assets = {
    "onboarding_1": "http://localhost:3845/assets/a7d6c61a97821259b55cf7d7e90e07ed5fe2e54f.png",
    "onboarding_2": "http://localhost:3845/assets/2e27449434f55be32d72ecec80335ba926455e8d.png",
    "onboarding_3": "http://localhost:3845/assets/1d28f6dbc852285c086120dc3c37193d78502682.png",
    "icon_robot": "http://localhost:3845/assets/91f6e38c2193af221cbd17ea26bd270f5292190f.png"
}

base_path = "/Users/abhishekdhobe/Code/indiekitios/IndieBuilderKit/Demo/IndieBuilderKitDemo/Assets.xcassets"

def create_imageset(name, url):
    imageset_path = os.path.join(base_path, f"{name}.imageset")
    os.makedirs(imageset_path, exist_ok=True)
    
    # Download image
    image_path = os.path.join(imageset_path, f"{name}.png")
    try:
        print(f"Downloading {name} from {url}...")
        urllib.request.urlretrieve(url, image_path)
        print(f"Downloaded {name}")
    except Exception as e:
        print(f"Failed to download {name}: {e}")
        return

    # Create Contents.json
    contents = {
        "images": [
            {
                "filename": f"{name}.png",
                "idiom": "universal",
                "scale": "1x"
            },
            {
                "idiom": "universal",
                "scale": "2x"
            },
            {
                "idiom": "universal",
                "scale": "3x"
            }
        ],
        "info": {
            "author": "xcode",
            "version": 1
        }
    }
    
    with open(os.path.join(imageset_path, "Contents.json"), "w") as f:
        json.dump(contents, f, indent=2)

for name, url in assets.items():
    create_imageset(name, url)

print("Asset download complete.")
