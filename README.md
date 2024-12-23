
# Horse Race


## Overview

  The **Horse Racing App** is a dynamic and interactive application designed for racing enthusiasts. It provides real-time updates about upcoming horse racing events, making it easy for users to stay informed and track races efficiently. Leveraging the **MVVM architecture** and **SwiftUI**, the app fetches data from a server through an API and presents it in a clean, user-friendly interface.
  
 **It has two modules:**
##### [1. MVVM Scalable architecture](https://github.com/kapilmhr/horse-race/blob/main/README.md#1-mvvm)
The implementation of this architecture is in the `main` branch.
##### [2. Modular Approach](https://github.com/kapilmhr/horse-race/blob/main/README.md#2-modular-architecture)
The implementation of this architecture is in the [`feat/modular-approach`](https://github.com/kapilmhr/horse-race/tree/feat/modular-approach) branch.


## Getting Started
### 1. Installation

To run this project locally, clone the repository and open it in Xcode.
```bash
git clone https://github.com/kapilmhr/horse-race.git
cd horse-race
open horse_racing.xcodeproj
```

Ensure you have the latest version of Xcode and an iOS device or simulator set up.

### 2. SwiftLint Installation and Setup for Xcode
#### Installation with Homebrew (Recommended)
```bash 
brew install swiftlint
```
####  Integrating SwiftLint into Xcode
-   Open your Xcode project. 
-   Go to your **Target** > **Build Phases**.
-   Click the **+** button and select **New Run Script Phase**.
-   In the new **Run Script Phase**, add the following script:
```bash
if [[ "$(uname -m)" == arm64 ]]
then
    export PATH="/opt/homebrew/bin:$PATH"
fi

if command -v swiftlint >/dev/null 2>&1
then
    swiftlint
else
    echo "warning: `swiftlint` command not found - See https://github.com/realm/SwiftLint#installation for installation instructions."
fi
```
> Ensure the **Run Script Phase** is placed after **Compile Sources**.

#### Configuring SwiftLint (Optional)

1.  Create a `.swiftlint.yml` file at the root of your project.
    
2.  You can customize the rules and behavior by modifying this `.swiftlint.yml` file.

**Reference: [SwiftLint](https://github.com/realm/SwiftLint)**

### 3. Layouts and Font Scaling with Accessibility in SwiftUI
#### Responsive Layouts for Font Scaling
-   Use SwiftUI's `.font` modifier with predefined text styles like `.body`, `.headline`, or `.caption` to ensure text scales dynamically.
-   Avoid fixed-size constraints, as they can truncate or distort content at larger font sizes.
-   Test your layouts using different text size settings (including accessibility sizes) via the **Accessibility Inspector** or device settings.
```swift
Text("Horse Race")
.bold()
.font(.subheadline)
```

#### Accessibility Labels in SwiftUI
The `accessibilityLabel` modifier in SwiftUI enhances  app’s compatibility with **VoiceOver** and other assistive technologies. It provides a meaningful, descriptive alternative to the text or UI elements, helping visually impaired users better understand your app.

```swift
Text("Race Number")
.bold()
.font(.headline)
.accessibilityLabel("Race Number")
```
## **Feature**

-   **Real-Time Updates:** Fetches horse racing data from a server and displays it in an organized, filtered list.
-   **Race Categories:** Displays races in three main categories:
    -   Horse Racing
    -   Greyhound Racing
    -   Harness Racing
-   **Upcoming Races:** The app shows the next five upcoming races, ensuring users stay up to date with events.
-   **Race Filtering:** Users can filter races by category for a more tailored experience or view all categories at once.
-   **Race Countdown:** Displays a countdown timer showing the remaining time until each race starts. If a race has already started, the elapsed time is shown.
-   **Timely Information:** Races that have already started and elapsed for more than 60 seconds are automatically removed from the list, ensuring that only relevant races are displayed.

  ### **Race List**

The app's primary screen displays a concise list of the next five upcoming races. Each race entry includes the following details:

<img src="https://github.com/kapilmhr/horse-race/raw/feat/docs/docs/racerow.png" width="350"/>

1.  **Category Image**: A thumbnail representing the category of the race (e.g., Horse, Greyhound, or Harness).
2.  **Race Number**: The unique identifier for each race (e.g., _R1_).
3.  **Meeting Name**: The location or event name where the race will take place.
4.  **Advertised start** *(Countdown Timer)* :
    -   Shows the remaining time until the race starts, such as `4m 5s` (4 minutes and 5 seconds).
    -   Displays a countdown of less than a minute, such as `22s` (22 seconds left).
    -   If a race has already started, it shows elapsed time with a negative value, such as `-20s` (race began 20 seconds ago).
    -   **Note**: Races that have elapsed more than 60 seconds are automatically removed from the list.

### **Filters by Category**

The app provides users with the ability to filter races by their specific categories:

1.  **Horse Racing**
2.  **Greyhound Racing**
3.  **Harness Racing**

<img src="https://github.com/kapilmhr/horse-race/raw/feat/docs/docs/categories.png" width="300"/>

Alternatively, users can **remove all filters** to view a comprehensive list of races across all categories. When no filter is applied, races are displayed in ascending order based on their advertised start time, ensuring a chronological view of upcoming events.


----------

### Preview
<img src="https://github.com/kapilmhr/horse-race/raw/feat/docs/docs/screen.png" width="300"/>

----------
## Architecture
### 1. MVVM
This app uses the **MVVM (Model-View-ViewModel)** architecture to manage data and business logic. The **SwiftUI** framework is employed for building a declarative, responsive UI. 


### Flow


```mermaid
graph LR
A[View] --User Interaction--> B[ViewModel]
B -- request data --> C[Repository]
C -- request Server data --> D[Service] 
D -- returns data --> C 
C -- returns data --> B 
B -- binds state --> A
```
------

-   **View**: Displays the UI and captures user interactions.
-   **ViewModel**: Handles user interaction logic, requests data, and binds data to the view.
-   **Repository**: Manages data fetching from multiple sources, including network requests.
-   **Service**: Responsible for making network requests to fetch data from the server.

 *Data flows from the Service to the Repository, from the Repository to the ViewModel, and then the ViewModel binds the data to the View.*
 
## Folder Structure

```
HorseRacingApp/
├── core/
│   ├── Colors.swift
│   ├── ViewState.swift
│   ├── Extensions.swift
├── feature/
│   ├── model/
│   │   ├── Race.swift
│   │   ├── RaceCategory.swift
│   ├── view/
│   │   ├── RaceListView.swift
│   │   └── RaceRowView.swift
│   ├── view model/
│   │   ├── RaceViewModel.swift
│   │   ├── TimerViewModel.swift
│   └── service/
│       ├── RaceService.swift
│   └── repository/
│       ├── RaceRepository.swift
├── network/
│   ├── NetworkManager.swift
│   ├── NetworkError.swift
│   └── Endpoint.swift
│
│
└── Tests/
    ├── RaceViewModelTests/
    │   ├── RaceViewModelTests.swift
    │   ├── RaceViewModelFilteringTests.swift
    │   ├── RaceViewModelAutoRefreshTests.swift
    │   └── RaceViewModelErrorHandlingTests.swift
    ├── Mocks/
    │   ├── MockRaceRepository.swift
    │   ├── MockRaceService.swift
    │   └── MockData.swift
    └── network/
        └── NetworkTests.swift

```

### 2. Modular Architecture 

The `core` module is imported into the `main app` module


```mermaid
graph LR
A[Main App Module] -- imports --> B[Core Module ]
B -- provides --> D[Utilities]
B -- provides --> E[Shared Components]
A -- interacts --> F[UI LayerMain Screen]
F -- triggers --> G[ViewModel ]
G --> H[Repository ]
H --> I[Service]
```

##### Flow Diagram
```mermaid
flowchart TD
    A[Main App] --> B[Main Module]
    B --> C[Components]

D[Library] --> E[Core]
        E-->|Import to main| B
        E-->|Use core feature| C
    A:::MainModule
    B:::integrationTests
    C:::e2eTests
    D:::library
    E:::core

    classDef MainModule fill:#FFDC74,stroke:#F59E00,stroke-width:2px,font-weight:bold
    classDef integrationTests fill:#FCA47E,stroke:#D94E1F,stroke-width:2px,font-weight:bold
    classDef e2eTests fill:#C2E0F9,stroke:#0C4A6E,stroke-width:2px
        classDef library fill:#FFDC74, stroke:#0C4A6E,stroke-width:2px,font-weight:bold
        classDef core fill:#C2E0F9,stroke:#0C4A6E,stroke-width:2px

```
### Folder Structure

```
├── core/
│   ├──/MainApp
│   ├── MainView.swift
│   ├── /CoreModule (from MyLibrary)
│   │   ├── Utilities/
│   │   │   ├── Extensions.swift
│   │   │   └── Helpers.swift
│   │   └── SharedComponents/
│   │       ├── LoadingIndicator.swift
│   │       └── CustomView.swift
|   ├── /feature
└── /Package.swift
```


## Testing

To ensure the app works as expected, we have a comprehensive suite of unit and UI tests. Follow the steps below to run tests and view test coverage reports.


### ****Run All Tests****:
In Xcode, navigate to the top menu and select:
```bash
Product > Test
```
> Alternatively, you can press `Cmd + U` to run all tests in the project.

### Coverage

Test coverage is tracked to ensure that key parts of the code are properly tested. After running the tests, you can view the coverage report in Xcode.

<img src="https://github.com/kapilmhr/horse-race/raw/feat/lint/docs/coverage.png" width="350"/>
