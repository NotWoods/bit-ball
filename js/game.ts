import "phaser";
import { Coords, Level } from "./level";
import * as platforms from "./platforms.json";

const worldWidth = 320;
const worldHeight = 480;
const dropButton: HTMLButtonElement = document.querySelector(
  'button[name="drop"]'
);

function levelFromUrl() {
  return new URL(window.location.href).searchParams.get("level");
}

function physicsOptions(type: keyof typeof platforms) {
  return {
    label: type,
    // @ts-expect-error density isn't on rotater yet
    density: platforms[type].density,
    restitution: platforms[type].bounce,
    friction: platforms[type].friction,
    isStatic: platforms[type].type === "static",
    ignoreGravity: type !== "ball",
  };
}

declare global {
  namespace Phaser.Physics.Matter.Matter {
    namespace Body {
      function create(options: { parts: any[] }): MatterJS.BodyType;
    }

    namespace Bodies {
      function rectangle(
        x: number,
        y: number,
        width: number,
        height: number
      ): any;
    }
  }
}

export class BitBallLevel extends Phaser.Scene {
  levelName: string;
  ballsDropped = 0;

  ball?: Phaser.Physics.Matter.Image;

  constructor(level = levelFromUrl()) {
    super(`Level ${level}`);
    if (!level) {
      throw new Error(`Missing level file`);
    }
    this.levelName = level;
  }

  preload() {
    this.load.json("level", `level/${this.levelName}.json`);
    this.load.image("indicator", "assets/indicator.png");
    for (const [platform, { image }] of Object.entries(platforms)) {
      if (platform !== "default") {
        this.load.image(platform, `assets/${image}`);
      }
    }
  }

  create() {
    // this.matter.world.setBounds(0, 0, worldWidth, worldHeight);
    const level = this.cache.json.get("level") as Level;

    this.add.image(level.spawn.x, 30, "indicator");
    dropButton.onclick = () => this.buildBall(level.spawn);

    this.buildGoal(level.goal);

    const canDrag = this.matter.world.nextGroup();

    // Platforms
    for (const platform of level.platforms) {
      const data = platforms[platform.type];
      const object = this.matter.add.image(
        platform.x,
        platform.y,
        platform.type
      );
      object.setBody({
        type: "rectangle",
        width: data.width,
        height: data.height,
        ...physicsOptions(platform.type),
      });
      const body = object.body as MatterJS.BodyType;

      switch (platform.type) {
        case "touch": {
          object.setCollisionGroup(canDrag);
          // fall through
        }
        case "rotater":
        case "rotater_small": {
          const length = 0;
          const stiffness = 0.5;
          this.matter.add.worldConstraint(body, length, stiffness, {
            pointA: { x: platform.x, y: platform.y },
          });
          break;
        }
      }
    }

    // @ts-expect-error collisionFilter isn't typed
    this.matter.add.mouseSpring({ collisionFilter: { group: canDrag } });
  }

  private buildBall(coords: Coords) {
    this.ball?.destroy();

    const body = this.matter.add.image(coords.x, coords.y, "ball");
    body.setBody({
      type: "circle",
      radius: platforms.ball.radius,
      ...physicsOptions("ball"),
    });

    this.ballsDropped++;
    console.log(`Dropping ball #${this.ballsDropped}`);
    this.ball = body;

    return body;
  }

  private buildGoal(coords: Coords) {
    const parts = platforms.goal.components.map((component) =>
      Phaser.Physics.Matter.Matter.Bodies.rectangle(
        component.x,
        component.y,
        component.width,
        component.height
      )
    );
    const compoundBody = Phaser.Physics.Matter.Matter.Body.create({
      parts,
    });

    const goal = this.matter.add.image(0, 0, "goal");
    goal.setExistingBody(compoundBody);
    compoundBody.label = "Goal";
    compoundBody.density = platforms.goal.density;
    compoundBody.restitution = platforms.goal.bounce;
    compoundBody.friction = platforms.goal.friction;
    compoundBody.render.sprite.xOffset = -0.3;
    goal.setStatic(true);
    goal.setX(coords.x);
    goal.setY(coords.y);

    return goal;
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
    default: "matter",
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
        hullColor: 0xd703d0,
      },
    },
  },
  scene: BitBallLevel,
};

export const game = new Phaser.Game(config);
