import "phaser";
import { Level } from "./level";
import * as platforms from './platforms.json';

const worldWidth = 320;
const worldHeight = 480;

function levelFromUrl() {
  return new URL(window.location.href).searchParams.get('level');
}

export class Demo extends Phaser.Scene {
  levelName: string;

  constructor(level = levelFromUrl()) {
    if (!level) {
      throw new Error(`Missing level file`)
    }

    super(`Level ${level}`);
    this.levelName = level;
  }

  preload() {
    this.load.json('level', `level/${this.levelName}.json`);
    for (const [platform, { image }] of Object.entries(platforms)) {
      if (platform !== 'default') {
        this.load.image(platform, `assets/${image}`);
      }
    }
  }

  create() {
    this.matter.world.setBounds(0, 0, worldWidth, worldHeight);
    const level = this.cache.json.get('level') as Level;

    // Ball
    this.matter.add.circle(level.spawn.x, level.spawn.y, platforms.ball.radius, {
      label: 'Ball',
      density: platforms.ball.density,
      restitution: platforms.ball.bounce,
      friction: platforms.ball.friction,
    });
    // Goal
    this.matter.add.fromVertices(level.goal.x, level.goal.y, platforms.goal.vertices, {
      label: 'Goal',
      density: platforms.goal.density,
      restitution: platforms.goal.bounce,
      friction: platforms.goal.friction,
      isStatic: true,
    })

    // Platforms
    for (const platform of level.platforms) {
      const data = platforms[platform.type]
      this.matter.add.rectangle(platform.x, platform.y, data.width, data.height, {
        label: platform.type,
        // @ts-expect-error density isn't on rotater yet
        density: data.density,
        restitution: data.bounce,
        friction: data.friction,
        isStatic: data.type === 'static',
        ignoreGravity: true,
      })
    }
  }
}

const config: Phaser.Types.Core.GameConfig = {
  type: Phaser.AUTO,
  backgroundColor: "transparent",
  transparent: true,
  width: worldWidth,
  height: worldHeight,
  scale: {
    mode: Phaser.Scale.FIT,
    autoCenter: Phaser.Scale.CENTER_BOTH,
  },
  physics: {
    default: 'matter',
    matter: {
      enableSleeping: true,
      debug: {
        showAxes: false,
        showAngleIndicator: true,
        angleColor: 0xe81153,

        showBroadphase: false,
        broadphaseColor: 0xffb400,

        showBounds: false,
        boundsColor: 0xffffff,

        showVelocity: true,
        velocityColor: 0x00aeef,

        showCollisions: true,
        collisionColor: 0xf5950c,

        showSeparation: false,
        separationColor: 0xffa500,

        showBody: true,
        showStaticBody: true,
        showInternalEdges: true,

        renderFill: false,
        renderLine: true,

        fillColor: 0x106909,
        fillOpacity: 1,
        lineColor: 0x28de19,
        lineOpacity: 1,
        lineThickness: 1,

        staticFillColor: 0x0d177b,
        staticLineColor: 0x1327e4,

        showSleeping: true,
        staticBodySleepOpacity: 1,
        sleepFillColor: 0x464646,
        sleepLineColor: 0x999a99,

        showSensors: true,
        sensorFillColor: 0x0d177b,
        sensorLineColor: 0x1327e4,

        showPositions: true,
        positionSize: 4,
        positionColor: 0xe042da,

        showJoint: true,
        jointColor: 0xe0e042,
        jointLineOpacity: 1,
        jointLineThickness: 2,

        pinSize: 4,
        pinColor: 0x42e0e0,

        springColor: 0xe042e0,

        anchorColor: 0xefefef,
        anchorSize: 4,

        showConvexHulls: true,
        hullColor: 0xd703d0
      }
    }
  },
  scene: Demo,
};

export const game = new Phaser.Game(config);
