import QtQuick 2.0

Item {
    Sprite {
        name: "black"
        source: "sprite_image.png"
        frameCount: 8
        frameWidth: 40
        frameHeight: 40
        frameRate: 20
    }
    Sprite {
        name: "red"
        source: "sprite_image.png"
        frameX: 120
        frameCount: 5
        frameWidth: 40
        frameHeight: 40
        frameRate: 20
    }
    Sprite {
        name: "blue"
        source: "sprite_image.png"
        frameX: 40
        frameY: 40
        frameCount: 2
        frameWidth: 40
        frameHeight: 40
        frameRate: 20
    }
}
