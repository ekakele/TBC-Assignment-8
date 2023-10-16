//Lecture 10 - Automatic Reference Counting (ARC), Access Controls

//Orbitron Space Station - Operations and Drones

//4-StationModule-ი With properties: moduleName: String და drone: Drone? (optional). Method რომელიც დრონს მისცემს თასქს.

fileprivate class StationModule {
    let moduleName: String
    var drone: Drone?
    
    init(moduleName: String) { self.moduleName = moduleName }
    
    func assignTask(task: String) {
        if drone?.task == nil {
            drone?.task = task
        }
    }
}


//1.ControlCenter-ი. With properties: isLockedDown: Bool და securityCode: String, რომელშიც იქნება რაღაც პაროლი შენახული. Method lockdown, რომელიც მიიღებს პაროლს, ჩვენ დავადარებთ ამ პაროლს securityCode-ს და თუ დაემთხვა გავაკეთებთ lockdown-ს. Method-ი რომელიც დაგვიბეჭდავს ინფორმაციას lockdown-ის ქვეშ ხომ არაა ჩვენი ControlCenter-ი.

fileprivate class ControlCenter: StationModule {
    private var isLockedDown = true
    private let securityCode = "JfkT_595"
    
    fileprivate override init(moduleName: String) {
        super.init(moduleName: moduleName)
    }
    
    func lockdown(password: String) {
        if password == securityCode {
            isLockedDown = true
            print("Correct password entered.")
        } else {
            isLockedDown = false
            print("Invalid password entered.")
        }
    }
    
    func lockdownStatus() {
        if isLockedDown == true {
            print("The Control Center is under lockdown.")
        } else {
            print("The Control Center is not under lockdown.")
        }
    }
}


//2-ResearchLab-ი. With properties: String Array - ნიმუშების შესანახად. Method რომელიც მოიპოვებს(დაამატებს) ნიმუშებს ჩვენს Array-ში.

fileprivate class ResearchLab: StationModule {
    private var samples: [String]
    
    init(moduleName: String, samples: [String]) {
        self.samples = samples
        super.init(moduleName: moduleName)
    }
    
    private func addSample(newSample: String) {
        samples.append(newSample)
    }
}


//3-LifeSupportSystem-ა. With properties: oxygenLevel: Int, რომელიც გააკონტროლებს ჟანგბადის დონეს. Method რომელიც გვეტყვის ჟანგბადის სტატუსზე.

fileprivate class LifeSupportSystem: StationModule {
    private var oxygenLevel: Int
    
    init(moduleName: String, oxygenLevel: Int) {
        self.oxygenLevel = oxygenLevel
        super.init(moduleName: moduleName)
    }
    
    func oxygenLevelStatus() {
        print("The current oxygen level is: \(oxygenLevel).")
    }
}


//5-ჩვენი ControlCenter-ი ResearchLab-ი და LifeSupportSystem-ა გავხადოთ StationModule-ის subClass.
//DONE ✅


//6-Drone. With properties: task: String? (optional), unowned var assignedModule: StationModule, weak var missionControlLink: MissionControl? (optional). Method რომელიც შეამოწმებს აქვს თუ არა დრონს თასქი და თუ აქვს დაგვიბჭდავს რა სამუშაოს ასრულებს ის.

class Drone {
    fileprivate var task: String?
    private unowned var assignedModule: StationModule
    private weak var missionControlLink: MissionControl?
    
    fileprivate init(assignedModule: StationModule) {
        self.assignedModule = assignedModule
    }
    
    fileprivate func droneTaskStatus() {
        if task == nil {
            print("The drone doesn't have an ongoing task.")
        } else {
            print("The drone currently is assigned to the task: \(task!).")
        }
    }
}


//7-OrbitronSpaceStation-ი შევქმნათ, შიგნით ავაწყოთ ჩვენი მოდულები ControlCenter-ი, ResearchLab-ი და LifeSupportSystem-ა. ასევე ამ მოდულებისთვის გავაკეთოთ თითო დრონი და მივაწოდოთ ამ მოდულებს რათა მათ გამოყენება შეძლონ. ასევე ჩვენს OrbitronSpaceStation-ს შევუქმნათ ფუნქციონალი lockdown-ის რომელიც საჭიროების შემთხვევაში controlCenter-ს დალოქავს.

class OrbitronSpaceStation {
    fileprivate var controlCenter: ControlCenter
    private var researchLab: ResearchLab
    fileprivate var lifeSupportSystem: LifeSupportSystem
    
    fileprivate init(controlCenter: ControlCenter, researchLab: ResearchLab, lifeSupportSystem: LifeSupportSystem) {
        self.controlCenter = controlCenter
        self.researchLab = researchLab
        self.lifeSupportSystem = lifeSupportSystem
        
        //creating drone objects
        let droneForControl = Drone(assignedModule: controlCenter)
        let droneForResearch = Drone( assignedModule: researchLab)
        let droneForSupport = Drone(assignedModule: lifeSupportSystem)
        
        //setting drones as a property of the related modules
        controlCenter.drone = droneForControl
        researchLab.drone = droneForResearch
        lifeSupportSystem.drone = droneForSupport
    }
    
    fileprivate func lockdownCS(passcode: String) {
        controlCenter.lockdown(password: passcode)
    }
}


//8-MissionControl. With properties: spaceStation: OrbitronSpaceStation? (optional). Method რომ დაუკავშირდეს OrbitronSpaceStation-ს და დაამყაროს მასთან კავშირი. Method requestControlCenterStatus-ი. Method requestOxygenStatus-ი. Method requestDroneStatus რომელიც გაარკვევს რას აკეთებს კონკრეტული მოდულის დრონი.

class MissionControl {
    private var spaceStation: OrbitronSpaceStation?
    
    fileprivate func connectWithOrbitronSpaceStation(station: OrbitronSpaceStation?) {
        if station != nil {
            spaceStation = station
            print("Connected to the Orbitron Space Station.")
        } else {
            print("Connection failed.")
        }
    }
    
    fileprivate func requestControlCenterStatus() {
        if let controlCenter = spaceStation?.controlCenter {
            controlCenter.lockdownStatus()
        }
    }
    
    fileprivate func requestOxygenStatus() {
        if let lifeSupportSystem = spaceStation?.lifeSupportSystem {
            lifeSupportSystem.oxygenLevelStatus()
        }
    }
    
    fileprivate func requestDroneStatus(droneToCheck: Drone) {
        droneToCheck.droneTaskStatus()
    }
}


//9-და ბოლოს შევქმნათ OrbitronSpaceStation, შევქმნათ MissionControl-ი, missionControl-ი დავაკავშიროთ OrbitronSpaceStation სისტემასთან, როცა კავშირი შედგება missionControl-ით მოვითხოვოთ controlCenter-ის status-ი. controlCenter-ის, researchLab-ის და lifeSupport-ის მოდულების დრონებს დავურიგოთ თასქები. შევამოწმოთ დრონების სტატუსები. შევამოწმოთ ჟანგბადის რაოდენობა. შევამოწმოთ ლოქდაუნის ფუნქციონალი და შევამოწმოთ დაილოქა თუ არა ხომალდი სწორი პაროლი შევიყვანეთ თუ არა.

//creating station module objects
private let controlCenter = ControlCenter(moduleName: "controlCenter")
private let researchLab = ResearchLab(moduleName: "researchLab", samples: ["Air", "Soil"])
private let lifeSupportSystem = LifeSupportSystem(moduleName: "lifeSupportSystem", oxygenLevel: 21)

//creating Orbitron station objects
let orbitronSpaceStation = OrbitronSpaceStation(
    controlCenter: controlCenter,
    researchLab: researchLab,
    lifeSupportSystem: lifeSupportSystem
)

//creating MissionControl Object
let missionControl = MissionControl()

//connecting Mission Control with Orbitron
missionControl.connectWithOrbitronSpaceStation(station: orbitronSpaceStation)

//requesting controlCenter status
missionControl.requestControlCenterStatus()

//assigning tasks to the module's drones
controlCenter.assignTask(task: "'Control security'")
researchLab.assignTask(task: "'Make laboratory analysis of samples'")
lifeSupportSystem.assignTask(task: "Check oxygen level in every 2 minutes")

//checking drones' status
missionControl.requestDroneStatus(droneToCheck: controlCenter.drone!)
missionControl.requestDroneStatus(droneToCheck: researchLab.drone!)
missionControl.requestDroneStatus(droneToCheck: lifeSupportSystem.drone!)

//check oxygen level status
missionControl.requestOxygenStatus()

//check lockdown func
controlCenter.lockdown(password: "djnf_786") //incorrect password

//check lockdown status
missionControl.requestControlCenterStatus()

//check lockdown func
orbitronSpaceStation.lockdownCS(passcode: "JfkT_595") //correct password

//check lockdown status
missionControl.requestControlCenterStatus()
