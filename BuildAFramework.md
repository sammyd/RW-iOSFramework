# How to create a framework for iOS


In the last tutorial I wrote, you learnt how to create a reusable knob control,
but it wasn't very clear exactly how you should reuse it. The simplest technique
is to provide the source code files for developers to drop into their Xcode
projects, but this isn't particularly user-friendly. You could compile your
code into a static library and pass this to the other developers - this can be
dropped straight into a project, however it requires that you distribute a
collection of header files as well. A framework offers a solution to this
problem, as it packages up a static library with header files, in one
easy-to-use package.

In this tutorial you'll start right at the beginning - building a static
library project in Xcode. From this you'll learn how to build an dev app which
has a dependency on this library project, before discovering how to convert the
static library project into a fully-fledged framework.


## Getting Started

The main purpose of this tutorial is to explain how to create a framework which
can be used in iOS, and therefore there will only be a small amount of objective-C
code described in the tutorial. In order to get started you should download the
source files for the `RWKnobControl` available in the zip file here. You'll see
how to use them as you go through the process of creating the first project in
the section __Creating a Static Library Project__.

## What is a Framework?

A framework collects a static library and the header files associated with it
together in a well-defined structure in such a way that Xcode understands how
to find the constituent parts. On OSX it is possible to create a dynamically
linked framework - i.e. one which is shared between multiple applications and is
linked at runtime. On iOS dynamically linked frameworks are not allowed - other
than the system ones provided by Apple. There are a few reasons behind this -
principally that apps on iOS are not allowed to share code - i.e. exactly the
purpose of dynamically linked frameworks. However, this doesn't mean that 
frameworks are completely off the table - statically linked frameworks can be
of great use - collecting the static library with the the header files required.

Since this is actually what a framework is comprised of, you're first going to
learn how to create and use a static library, so that when the tutorial moves on
to building a framework then it doesn't come across as smoke and mirrors magic.


## Creating a Static Library project

Open Xcode and create a new static library project by clicking __File > New > Project__
and selecting __iOS > Framework & Library > Cocoa Touch Static Library__.

![Creating a static library](img/creating_static_lib.png)

Name the product `RWUIControls` and save the project in an empty directory.

![Naming the static library](img/options_for_static_lib.png)

A static library project is made up of header files and `.m` files, which are
compiled to make the library itself.

To make life easier for developers using your library (and later framework) you're 
going to make it so that the only need to import one header file in order to access
all the classes you wish to be available to them. When creating the static
library, Xcode created __RWUIControls.h__ and __RWUIControls.m__ - you don't
need the implementation file, so right click on __RWUIControls.m__ and select
delete. You don't need the file, so move it to the trash when asked. Open up
__RWUIControls.h__ and replace the content with the following:

    #import <UIKit/UIKit.h>

This represents an import which the entire library needs, and as you create the
different component classes you'll add them to this file, ensuring that they
become accessible for users.

Because the project you're building today relies on __UIKit__, and the static
library project doesn't link against it by default, add this as a dependency.
Select the project in the navigator, and then choose the __RWUIControls__
target in then central pane. Click on __Build Phases__ and then expand the
__Link Binary with Libraries__ section. Click the __+__ to add a new framework
and navigate to find __UIKit__ before clicking add.

![Add UIKit Dependency](img/add_uikit_dependency.gif)

A static library is of no use unless it is combined with a selection of header
files which can be used by the compiler as a manifest of what classes (and
methods on those classes) exist within the binary. Some of the classes you
create in your library will be publicly accessible, but some will be for
internal use only. Next you need to add an operation in the build which will
collect together the public header files and put them somewhere accessible.
Later, these will be copied into the framework.

Whilst still looking at the same __Build Phases__ screen in Xcode as before,
find __Editor > Add Build Phase > Add Copy Headers Build Phase__.

Note: If this option is grayed out in the menu, then try clicking in the white
area below the existing build phases to get the correct focus.

![Add copy headers build phase](img/add_copy_headers_build_phase.gif)

You can now add the __RWUIControls.h__ file to the public section of this new
build phase by dragging it from the navigator to the public part of the panel.
This will ensure that this header file is available for users of your library.

![Add header to public](img/add_header_to_public.gif)

Note: All the header files that are included in any of your public headers must
also be made public. Otherwise you'll get compiler errors whilst attempting to
use the library.

### Creating a UI Control

Now that you've got your project set up, it's time to start adding some
functionality to your library - otherwise why would anybody want to use it?
Since the point of this tutorial is to describe how to build a framework, not
how to build a UI control, we'll borrow the code from the last tutorial. In the
zip file you downloaded there is a directory __RWKnobControl__. Drag it from the
finder into the __RWUIControls__ group in Xcode.

![Drag to import RWKnobControl](img/drop_rwuiknobcontrol_from_finder.png)

Choose to __Copy items into destination group's folder__ and ensure that the
new files are being added to the __RWUIControls__ static library target.

![Import settings for RWKnobControl](img/import_settings_for_rwknobcontrol.png)

This will add the `.m` files to the compilation list and, by default, the `.h`
files to the __Project__ group. This means that they will not be shared - i.e.
private.

![Default target membership](img/default_header_membership.png)

Note: The 3 target names are somewhat confusing: _public_ is shared as expected,
but _private_ is not quite the same as _project_. _Private_ headers can be shared as
private headers - not exactly what you want. Therefore, your headers should
either be in the _public_ group (shared) or the _project_ group (not-shared).

You want to share the main control header - __RWKnobControl.h__, and there are
several ways you can do this. The first is to simply drag the file from the
_project_ group to the _public_ group in the __Copy Headers__ panel.

![Drag header to public](img/drag_header_to_public.gif)

Alternatively, you might find it easier to change the membership in the
__Target Membership__ panel when editing the file. This is likely to be more
convenient as you continue to add and develop the library.

![Selecting target membership](img/header_membership.png)

Note: as you continue to add new classes to your library, don't forget to keep
the membership up-to-date. Make as few headers public as possible, and ensure
that the remainder are in the _project_ group.

The other thing that you need to do with your control's header file is add it
to the library's main header file - __RWUIControls.h__. This means that a
developer using your library just needs to include one file, and doesn't have
to work out exactly which pieces she needs:

    #import <RWUIControls/RWUIControls.h>

Therefore, add the following to __RWUIControls.h__:

    // Knob Control
    #import <RWUIControls/RWKnobControl.h>

### Configuring Build Settings

You are now very close to being able to build this project and create your
first ever static library, however, there are a few settings that you need to
configure in order to make the library as user-friendly as possible.

Firstly you need to provide a directory name for the public headers to be
copied to. This will ensure that you can locate the relevant headers when you
come to use the static library.

Click on the project in the Project Navigator, and then select the
__RWUIControls__ static library target. Select the __Build Settings__ tab and
then search for __"public headers"__. Double click on the __Public Headers
Folder Path__ and enter the following:

    include/$(PROJECT_NAME)

![Set the public header location](img/public_headers_path.png)

You'll see this directory later on.

The other settings you need to change are related to what gets left in the
binary library. The compiler gives you the option of removing code which is
never accessed (dead code) and also to remove debug symbols (i.e. function
names and other details used in debugging). Since you're creating a framework
for others to use you can disable both of these kinds of stripping, and let the
user choose when they build their dependent app. To do this, use the same
search field again, this time to update the following settings:

- "Dead Code Stripping". Set this to `NO`
- "Strip Debug Symbols During Copy". Set this to `NO` for all configs
- "Strip Style". Set this to `Non-Global Symbols`

It has been a while coming, but you can now build the project. Unfortunately
there isn't a lot to see yet, but at least you can confirm it builds.

To build, select the target as __iOS Device__ and press __⌘ + B__ to perform
the build. Once this has completed then the __libRWUIControls.a__ product in the
__Products__ group of the Project Navigator will turn from red to black,
signaling that it now exists. Right click on __libRWUIControls.a__ and select
__Show in Finder__.

![Successful first build](img/successful_first_build.png)

In this directory you can see the static library itself (__libRWUIControls.a__)
and the directory you specified for the public headers - __include/RWUIControls__.
Notice that the headers you made public exist in the folder as you would expect
them to.

### Creating a dependent development project

Developing a UI Controls library for iOS would be extremely difficult if you
couldn't actually see what you were doing - which seems to be the case at the
moment. Therefore, in this section you're going to create a new Xcode project,
which will have a dependency on the library project, allowing you to develop
the framework with a dev app. Crucially, the code for the dev app will be
completely separate from the library itself, which makes for a lot cleaner
structure.

Begin by closing the static library project by clicking __File > Close
Project__. Then create a new project with __File > New > Project__. Select
__iOS > Application > Single View Application__, call the new project
__UIControlDevApp__ and specify that it should be __iPhone__ only. Save the
project in the same directory as you chose for __RWUIControls__.

To add a dependency on the __RWUIControls__ library, drag
__RWUIControls.xcodeproj__ from the Finder into the __UIControlDevApp__ group
in Xcode.

![Import Library into Dev App](img/import_library_into_dev_app.png)

You can now navigate around the library project, inside the dev app project.
This is perfect because it means that you can edit code inside the library and
run up the dev app to check the changes.

Note: You can't have the same project open in 2 different Xcode windows -
therefore, if you're unable to navigate the library project check that you
don't have it open elsewhere.

Rather than recreate the dev app from the last tutorial, you can copy the same
code in. First of all, select __Main.storyboard__, __RWViewController.h__ and
__RWViewController.m__ and delete them by right clicking and selecting
__Delete__. Then copy the the __DevApp__ folder from the zip you downloaded
right into the __UIControlDevApp__ group in Xcode.

![Adding files to dev app](img/adding_files_to_dev_app.gif)

To add a build dependency for the dev app on the static library, select the
__UIControlDevApp__ project in the Project Navigator, and navigate to the
__Build Phases__ tab of the __UIControlDevApp__ target. In the Project
Navigator, navigate to the __Products__ group of the __RWUIControls__ project,
and then drag __libRWUIControls.a__ from the Project Navigator into the __Link
Binary With Libraries__ panel.

![Adding library dependency](img/adding_library_dependency.gif)

Now you can finally build and run an app and see it in action. If you followed
the previous tutorial on building a knob control, then you'll recognize the
simple app that you've built.

![First Build and run of dev app](img/dev_app_buildrun1.png)

The beauty of using these nested projects like this is that you can continue to
work on the library itself, without leaving the dev app project - whilst
maintaining the code in different places. Each time you build the project
you're also checking that you've got the public/project header membership set
correctly, since the dev app will be unable to build if it is missing required
headers.


## Building a Framework

You would be excused for thinking that when you started this tutorial you were
promised a framework, and so far you've done a lot of work and there is no
framework in sight. Well, this section will change that. The reason that you've
got this far without doing anything towards creating a framework is that a
framework is pretty much a static library and a collection of headers - exactly
what you've built so far. There are a couple of things which make a framework
special:

1. The directory structure. Frameworks have a special directory structure which
is recognized by Xcode. You will create a build task which will create this
structure.
2. The 'slices' in the static library. Currently, when the library is built, it
is only built for the currently required architecture (i.e. i386, arm7 etc). In
order for a framework to be useful it needs to include builds for all the
architectures it needs to run on. You will create a new build product which
will build the required architectures and place them in the framework.

There is a quite a lot of scripting magic in this section, but bear with it -
it's not nearly as complicated as it looks.


### Framework Structure

As mentioned previously, a framework has a special directory structure which
looks like this:

IMAGE OF FRAMEWORK DIRECTORY STRUCTURE

To create this, you need to add a script which will create this as part of the
static library build process. Select the __RWUIControls__ project in the
Project Navigator, and select the __RWUIControls__ static library target.
Choose the __Build Phases__ tab and add a new script by selecting __Editor >
Add Build Phase > Add Run Script Build Phase__.

![Create new run script build phase](img/add_run_script_build_phase.png)

This creates a new panel in the build phases, which allows you to run an
arbitrary script at some point during the build. You can change when the script
runs by dragging the panel around in the list; for the framework project you
want the script to be run last, so you can leave it where it is placed by
default.

![Blank run script phase](img/new_run_script_build_phase.png)

Rename the script by double clicking on the panel title ("Run Script") and
replacing it with "Build Framework".

![Rename script](img/rename_script.png)

Paste the following script in the script field:

    set -e

    export FRAMEWORK_LOCN="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework"

    # Create the path to the real Headers dir
    mkdir -p "${FRAMEWORK_LOCN}/Versions/A/Headers"

    # Create the required symlinks
    /bin/ln -sfh A "${FRAMEWORK_LOCN}/Versions/Current"
    /bin/ln -sfh Versions/Current/Headers "${FRAMEWORK_LOCN}/Headers"
    /bin/ln -sfh "Versions/Current/${PRODUCT_NAME}" \
                 "${FRAMEWORK_LOCN}/${PRODUCT_NAME}"

    # Copy the public headers into the framework
    /bin/cp -a "${TARGET_BUILD_DIR}/${PUBLIC_HEADERS_FOLDER_PATH}/" \
               "${FRAMEWORK_LOCN}/Versions/A/Headers"

This script first creates the __RWUIControls.framework/Versions/A/Headers__
directory before then creating the 3 symlinks required for a framework:

- __Versions/Current__ => __A__
- __Headers__ => __Versions/Current/Headers__
- __RWUIControls__ => __Versions/Current/RWUIControls__

Finally, the public header files are copied into the __Versions/A/Headers__
directory from the public headers path you specified before. The __-a__
argument ensures that the modified times are not changed as part of the copy,
thereby preventing unnecessary rebuilds.

Select the __RWUIControls__ static library scheme, and __iOS Device__ build
target and build using __⌘ + B__.

![Build static lib target](img/build_target_static_lib.png)

Right click on the __libRWUIControls.a__ static library in the __Products__
group of the __RWUIControls__ project, and select __Show In Finder__.

![Static lib: show in finder](img/static_lib_view_in_finder.png)

Within this build directory you can see the __RWUIControls.framework__, and you
can confirm that the correct directory structure has been created and
populated:

![Created framework structure](img/created_framework_directory_structure.png)

This is step along the path to completing a framework, but you'll notice that
there there isn't a static lib in there yet - that's what you're going to sort
next.



### Multi-architecture Build

iOS apps need to run on a lot of different architectures:

- __arm7__ Used in the oldest iOS7-supporting devices
- __arm7s__ As used in iPhone 5 and 5C
- __arm64__ For the 64-bit ARM processor in iPhone 5S
- __i386__ For the 32-bit simulator
- __x86_64__ Used in 64-bit simulator

Each architecture requires a different binary, and when you build an app Xcode
will build the correct architecture for whatever you're currently doing - i.e.
if you've asked to run in the simulator then it'll only build the i386 version
(or x86_64 for 64-bit). This means that builds are as fast as they can be. When
you archive an app (or build in release mode) in preparation for upload to the
app store, then Xcode will build for all 3 ARM architectures, allowing the app
to be run on all possible devices.

When you build your framework, you want developers using it to be able to use
it for all the possible architectures, and therefore you need to make Xcode
build for all 5 architectures. This process creates a so-called 'fat' binary,
which contains a slice for each of the architectures.

Note: This actually highlights another reason for using a dev app which has a
dependency on the static library: the library will only be built for the
architecture currently required for the dev app, and will actually only be
rebuilt if something has changed. This means the development cycle is as quick
as possible.

The framework will be created using a new target in the __RWUIControls__
project. To create it select the __RWUIControls__ project in the Project
Navigator and then click the __Add Target__ button at the bottom of the
existing targets.

![Add Target Button](img/add_target_button.png)

Navigate to __iOS > Other > Aggregate__, click next and name the target
__Framework__.

![Aggregate target](img/select_aggregate_target.png)

To ensure that when this new framework target is built, the static library is
built as well, then add a dependency on the static library target. Select the
framework target in the library project and add a dependency in the __Build
Phases__ tab.

![Add dependency to framework target](img/add_dependency_to_framework_target.gif)

The main build part of this target is the multi-platform building, which you'll
perform using a script. As you did before, create a new "Run Script" build
phase by selecting the __Build Phases__ tab of the __Framework__ target, and
clicking __Editor > Add Build Phase > Add Run Script Build Phase__.

![Add build script to framework](img/framework_add_run_script_build_phase.png)

Change the name of the script as before by double clicking on __Run Script__ -
call it __MultiPlatform Build__.

Paste the following into the script text box:

    set -e

    # If we're already inside this script then die
    if [ -n "$RW_MULTIPLATFORM_BUILD_IN_PROGRESS" ]; then
      exit 0
      fi
    export RW_MULTIPLATFORM_BUILD_IN_PROGRESS=1

    RW_FRAMEWORK_NAME=${PROJECT_NAME}
    RW_INPUT_STATIC_LIB="lib${PROJECT_NAME}.a"
    RW_FRAMEWORK_LOCATION="${BUILT_PRODUCTS_DIR}/${RW_FRAMEWORK_NAME}.framework"

- `set -e` ensures that if any part of the script should fail then the entire
script will fail. This makes sure that you don't end up with a partially-built
framework.
- Next, the `RW_MULTIPLATFORM_BUILD_IN_PROGRESS` variable is used to determine
whether the script has been called recursively. If it has, then quit.
- Then set up some variables - the framework name will be the same as the
project i.e. __RWUIControls__, and the static lib that will be used is
__libRWUIControls.a__.

The next part of the script sets up some functions which will be used later on.
Paste the following at the bottom of the script:

    function build_static_library {
        # Will rebuild the static library as specified
        #     build_static_library sdk
        xcrun xcodebuild -project "${PROJECT_FILE_PATH}" \
                         -target "${TARGET_NAME}" \
                         -configuration "${CONFIGURATION}" \
                         -sdk "${1}" \
                         ONLY_ACTIVE_ARCH=NO \
                         BUILD_DIR="${BUILD_DIR}" \
                         OBJROOT="${OBJROOT}" \
                         BUILD_ROOT="${BUILD_ROOT}" \
                         SYMROOT="${SYMROOT}" $ACTION
    }

    function make_fat_library {
        # Will smash 2 static libs together
        #     make_fat_library in1 in2 out
        xcrun lipo -create "${1}" "${2}" -output "${3}"
    }

- `build_static_library` takes an __SDK__ as an argument (e.g. __iphoneos7.0__)
and will build the static lib. Most of the arguments are passed directly from
the current build job, the difference being that `ONLY_ACTIVE_ARCH` is set to
ensure that all architectures are build for the current SDK.
- `make_fat_library` uses `lipo` to join two static libraries into one. Its
arguments are two input libraries followed by the desired output location.

The next section of the script determines some more variables - in order to use
the two methods. You need to know what the other SDK is (e.g. iphoneos7.0
should go to iphonesimulator7.0 and vice versa), and to locate the build
directory for that SDK. Paste the following at the end of the script:

    # Extract the platform (iphoneos/iphonesimulator) from the SDK name
    if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]; then
      RW_SDK_PLATFORM=${BASH_REMATCH[1]}
    else
      echo "Could not find platform name from SDK_NAME: $SDK_NAME"
      exit 1
    fi

    # Extract the version from the SDK
    if [[ "$SDK_NAME" =~ ([0-9]+.*$) ]]; then
      RW_SDK_VERSION=${BASH_REMATCH[1]}
    else
      echo "Could not find sdk version from SDK_NAME: $SDK_NAME"
      exit 1
    fi

    # Determine the other platform
    if [ "$RW_SDK_PLATFORM" == "iphoneos" ]; then
      RW_OTHER_PLATFORM=iphonesimulator
    else
      RW_OTHER_PLATFORM=iphoneos
    fi

    # Find the build directory
    if [[ "$BUILT_PRODUCTS_DIR" =~ (.*)$RW_SDK_PLATFORM$ ]]; then
      RW_OTHER_BUILT_PRODUCTS_DIR="${BASH_REMATCH[1]}${RW_OTHER_PLATFORM}"
    else
      echo "Could not find other platform build directory."
      exit 1
    fi

All four of these statements are very similar - using string comparison (and
regex) to determine `RW_OTHER_PLATFORM` and `RW_OTHER_BUILT_PRODUCTS_DIR`. The
four `if` statements in more detail:

1. `SDK_NAME` will be of the form `iphoneos7.0` or `iphonesimulator6.1` (for
example). This regex extracts the non-numeric characters at the beginning of
this string, and hence will result in `iphoneos` or `iphonesimulator`.
2. This regex pulls the numeric version number from the end of the `SDK_NAME`
variable - i.e. `7.0` or `6.1` etc.
3. Here a simple string comparison switches `iphonesimulator` for `iphoneos`
and vice versa.
4. Take the platform name from the end of the build products directory path,
and replace it with the other platform. This ensures that the build directory
for the other platform can be found. This will be used when joining the two
static libraries.

Now you can trigger the build for the other platform, and then join the
resultant static libraries. Paste the following on the end of the script:

    # Build the other platform.
    build_static_library "${RW_OTHER_PLATFORM}${RW_SDK_VERSION}"

    # If we're currently building for iphonesimulator, then need to rebuild
    #   to ensure that we get both i386 and x86_64
    if [ "$RW_SDK_PLATFORM" == "iphonesimulator" ]; then
        build_static_library "${SDK_NAME}"
    fi


    # Join the 2 static libs into 1 and push into the .framework
    make_fat_library "${BUILT_PRODUCTS_DIR}/${RW_INPUT_STATIC_LIB}" \
                     "${RW_OTHER_BUILT_PRODUCTS_DIR}/${RW_INPUT_STATIC_LIB}" \
                     "${RW_FRAMEWORK_LOCATION}/Versions/A/${RW_FRAMEWORK_NAME}"

- First there's a call to build the other platform using the function you
defined beforehand
- If you're currently building for the simulator, then by default Xcode will
only build the architecture that is currently required (e.g. __i386__ or
__x86_64__). In order to build both architectures, this second call to
`build_static_library` rebuilds with the `iphonesimulator` SDK, and ensures
that both architectures are built.
- Finally a call to `make_fat_library` joins the static lib in the current
build directory with that in the other build directory to make the
multi-architecture fat static library. This is placed inside the framework.

The final commands of the script are simple copy commands. Paste the following
at the end of the script:

    # Ensure that the framework is present in both platorm's build directories
    cp -a "${RW_FRAMEWORK_LOCATION}/Versions/A/${RW_FRAMEWORK_NAME}" \
          "${RW_OTHER_BUILT_PRODUCTS_DIR}/${RW_FRAMEWORK_NAME}.framework/Versions/A/${RW_FRAMEWORK_NAME}"

    # Copy the framework to the user's desktop
    ditto "${RW_FRAMEWORK_LOCATION}" "${HOME}/Desktop/${RW_FRAMEWORK_NAME}.framework"

- The first command ensures that the framework in both platform build
directories is the same, simply to reduce the potential confusion.
- The second copies the completed framework to the user's desktop. This is an
optional step, but I find that it's a lot easier to have the framework placed
somewhere easily accessible.

Select the __Framework__ aggregate scheme, and press __⌘ + B__ to build the
framework.

![Aggregate framework scheme](img/select_framework_aggregate_scheme.png)

This will build and place a __RWUIControls.framework__ on your desktop.

![Built framework on desktop](img/built_framework_on_desktop.png)

In order to check that the multi-platform build has worked, fire up a terminal,
and navigate to the framework on the desktop, as follows:

    ➜  ~  cd Desktop/RWUIControls.framework
    ➜  RWUIControls.framework  xcrun lipo -info RWUIControls

The first command navigates into the framework itself, and then the second line
uses the `lipo` command to get info on the __RWUIControls__ static library.
This will list the slices present in the library.

![Architectures in fat library](img/architectures_in_fat_library.png)

You can see here that there are 5 slices - __i386__, __x86_64__, __arm7__,
__arm7s__ and __arm64__, which is exactly what you set out to build. Had you
run the `lipo -info` command beforehand then you would have seen a subset of
these slices.


## How to use a framework

You've put in a fair amount of work to build this framework, and you are yet to
see what the point of it was. Well, that's what you'll discover in this
section. One of the primary advantages in using a framework is its simplicity
in use. You're going to create a simple iOS app which uses the
__RWUIControls.framework__ that you've just built.

Start by creating a new project in Xcode. Click __File > New > Project__ and
select __iOS > Application > Single View Application__. Call your new app
__ImageViewer__, set it for __iPhone__ only and save it in the same directory
you've used for the previous two projects. This app will display an image and
allow the user to change its rotation using a __RWKnobControl__.

A sample image has been provided in the __ImageViewer__ directory of the zip
file you downloaded. Drag __sampleImage.jpg__ from the finder into the __ImageViewer__
group inside Xcode.

![Drag sample image into Xcode](img/drag_sample_image_into_xcode.png)

Ensure that the __Copy items into destination group's folder__ check box is
checked, and click __Finish__ to complete the import.

Importing a framework follows almost exactly the same process. Drag
__RWUIControls.framework__ from the desktop into the __Frameworks__ group in
Xcode. Again, ensure that __Copy items into destination group's folder__ is
checked.

![Import Framework](img/import_framework.gif)

Open up __RWViewController.m__ and replace the code with the following:

    #import "RWViewController.h"
    #import <RWUIControls/RWUIControls.h>

    @interface RWViewController ()
        @property (nonatomic, strong) UIImageView *imageView;
        @property (nonatomic, strong) RWKnobControl *rotationKnob;
    @end

    @implementation RWViewController

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Create UIImageView
        CGRect frame = self.view.bounds;
        frame.size.height *= 2/3.0;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(frame, 0, 20)];
        self.imageView.image = [UIImage imageNamed:@"sampleImage.jpg"];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.imageView];
        
        // Create RWKnobControl
        frame.origin.y += frame.size.height;
        frame.size.height /= 2;
        frame.size.width  = frame.size.height;
        self.rotationKnob = [[RWKnobControl alloc] initWithFrame:CGRectInset(frame, 10, 10)];
        CGPoint center = self.rotationKnob.center;
        center.x = CGRectGetMidX(self.view.bounds);
        self.rotationKnob.center = center;
        [self.view addSubview:self.rotationKnob];
        
        // Set up config on RWKnobControl
        self.rotationKnob.minimumValue = -M_PI_4;
        self.rotationKnob.maximumValue = M_PI_4;
        [self.rotationKnob addTarget:self
                              action:@selector(rotationAngleChanged:)
                    forControlEvents:UIControlEventValueChanged];
    }
        
    - (void)rotationAngleChanged:(id)sender
    {
        self.imageView.transform = CGAffineTransformMakeRotation(self.rotationKnob.value);
    }
        
    - (NSUInteger)supportedInterfaceOrientations
    {
        return UIInterfaceOrientationMaskPortrait;
    }

    @end

This is a simple view controller which does the following:

- Import the framework header with `#import <RWUIControls/RWUIControls.h>`.
- Set up a couple of private properties to hold the `UIImageView` and the
`RWKnobControl`.
- Create a `UIImageView`, and use the __sampleImage__ that you added to the
project before.
- Create a `RWKnobControl` and position it appropriately.
- Set some properties on the knob control, including setting the change event
handler to be the `rotationAngleChanged:` method.
- The `rotationAngleChanged:` method simply updates the `transform` property of
the `UIImageView` so that the image rotates as the knob control is moved.

For further details on how to use the `RWKnobControl` check out the previous
tutorial, which explains how to create it.

If you build and run this project you'll see a simple app, which as you change
the value of the knob control will rotate the image.

![Image Viewer Rotating](img/image_viewer_rotating.gif)


## Using a bundle for resources

You may have noticed that the __RWUIControls__ framework that you've built so
far only consists of code and headers - i.e. you haven't used any other assets
such as imagery. This is a limitation of a framework, in that it can only
contain header files and a static library. In this section you'll learn how to
use a bundle to collect assets, which can then be distributed alongside the
framework itself.

You're going to create a new UI control to be part of the __RWUIControls__
library - a ribbon control. This will put an image of a ribbon on the top right
hand corner of a `UIView`.


### Creating a bundle

The resources will be stored inside a __.bundle__ object, which takes the form
of an additional target on the __RWUIControls__ project. Open the
__UIControlDevApp__ project, and select the __RWUIControls__ project within
there. Click the __Add Target__ button, and then navigate to __OS X > Framework
& Library > Bundle__. Call the bundle __RWUIControlsResources__ and make sure
to select __Core Foundation__ from the framework selection box.

![Add bundle target](img/add_bundle_target.gif)

There are a couple of build settings which need configuring since you're
building a bundle for use in iOS as opposed to the default OSX. Select the
__RWUIControlsResources__ target and then the __Build Settings__ tab. Search
for __base sdk__, select the __Base SDK__ line and press __delete__. This will
switch from OSX to iOS.

![Remove the Base SDK override](img/bundle_set_base_sdk.png)

You also need to change the product name to __RWUIControls__. Search this time
for __bundle name__ and double click to edit. Replace __${TARGET_NAME}__ with
__RWUIControls__.

![Set bundle product name](img/bundle_set_product_name.png)

By default images which have 2 resolutions (i.e. include an `@2x` version) will
be combined into a multi-resolution TIFF, which is not what you want. Search
for __hidpi__ and change the __COMBINE_HIDPI_IMAGES__ setting from __YES__ to
__NO__.

![Turn off HIDPI images merging](img/bundle_hidpi_images.png)

In order that the bundle gets built whenever the framework gets built, then add
it as a dependency to the __Framework__ aggregate target. Select the
__Framework__ target, and then the __Build Phases__ tab. Expand the __Target
Dependencies__ panel, click the __+__, and then select the
__RWUIControlsResources__ target to add it as a dependency.

![Add bundle as framework dependency](img/add_bundle_as_framework_dependency.gif)

Open the __MultiPlatform Build__ panel, and add the following to the end of the
script:

    # Copy the resources bundle to the user's desktop
    ditto "${BUILT_PRODUCTS_DIR}/${RW_FRAMEWORK_NAME}.bundle" \
          "${HOME}/Desktop/${RW_FRAMEWORK_NAME}.bundle"

This command will copy the built bundle to the user's desktop in the same way
that the framework gets copied. If you build the framework scheme now then
you'll see that the bundle appears on the desktop.

![Bundle on desktop](img/bundle_on_desktop.png)


### Importing the bundle into the dependent project

In order to develop against this new bundle, you need to be able to use the
bundle in the dev app. This means you must add it as both a dependency, and a
object to copy across to the app.

Select the __UIControlDevApp__ project in the Project Navigator, and then click
on the __UIControlDevApp__ target. Expand the __Products__ group of the
__RWUIControls__ project and drag __RWUIControls.bundle__ to the __Copy Bundle
Resources__ panel inside the __Build Phases__ tab. In the __Target
Dependencies__ panel, click the __+__ to add a new dependency, and then select
__RWUIControlsResources__.

![Add bundle for dev project](img/add_bundle_to_dev_project.gif)


### Building a ribbon view

That's all the setup required - now you can go ahead and build a new control.
Again, the code and imagery has been provided since that isn't the primary
purpose of this tutorial. Drag the __RWRibbon__ directory from inside the zip
file into the __RWUIControls__ group within the __RWUIControls__ project.

![Drag RWRibbon into project](img/drag_rwribbon.png)

Choose to __Copy the items into the destination group's folder__, and select
that they are part of the __RWUIControls__ static lib target.

![RWRibbon membership](img/rwribbon_membership.png)

The only important part of the source code you've added is how you reference
images. If you take a look at the `addRibbonView` method inside the
__RWRibbonView.m__ file, then you'll see the relevant line:

    UIImage *image = [UIImage imageNamed:@"RWUIControls.bundle/RWRibbon"];

The important part is that the bundle behaves like a directory - so it's really
simple to reference an image inside a bundle.

To add the images to bundle, choose them in turn, and then, in the right hand
panel, select that they should belong to the __RWUIControlsResources__ target.

![RWRibbon Image membership](img/rwribbon_image_membership.png)

The __RWRibbon.h__ header file needs to be exported as public, so select the
file, and then choose __Public__ from the drop down menu in the __Target
Membership__ panel.

![RWRibbon Header membership](img/rwribbon_header_membership.png)

Finally, since you've added a new control, add the header to the framework's
header file. Open __RWUIControls.h__ and add the following lines:

    // RWRibbon
    #import <RWUIControls/RWRibbonView.h>


### Adding the ribbon to the dev app

Open __RWViewController.m__ in the __UIControlDevApp__ project, and add the
following ivar between the curly braces in the `@interface` section:

    RWRibbonView  *_ribbonView;

And to actually create a ribbon view, add the following at the end of
`viewDidLoad`:

    // Creates a sample ribbon view
    _ribbonView = [[RWRibbonView alloc] initWithFrame:self.ribbonViewContainer.bounds];
    [self.ribbonViewContainer addSubview:_ribbonView];
    // Need to check that it actually works :)
    UIView *sampleView = [[UIView alloc] initWithFrame:_ribbonView.bounds];
    sampleView.backgroundColor = [UIColor lightGrayColor];
    [_ribbonView addSubview:sampleView];

Build and run the the __UIControlDevApp__ scheme and you'll see the new ribbon
control at the bottom of the app:

![Dev app with ribbon](img/dev_app_with_ribbon.png)


### Using the bundle in ImageViewer

All that remains in this pretty extensive tutorial is to take a look at how to
use this new bundle inside another app - the __ImageViewer__ app you built
before.

To start, make sure that your framework and bundle are up to date. Select the
__Framework__ scheme and then press __⌘ + B__ to build it.

Open up the __ImageViewer__ project, find the __RWUIControls.framework__ item
inside the __Frameworks__ group and delete it, choosing to move it to the trash.
Then, as before, drag the __RWUIControls.framework__ from your desktop to the
__Frameworks__ group. This is necessary because the framework has changed since
you first imported it.

![Delete framework](img/delete_framework.png)

To import the bundle, simply drag it from the desktop to the __ImageViewer__
group. Choose to __Copy items into destination group's folder__ and ensure that
it is added to the __ImageViewer__ target.

![Import bundle](img/import_bundle.png)

You're going to add the ribbon to the image which gets rotated, so there are a
few simple changes to make to the code in __RWViewController.m__.

Change the type of the `imageContainer` property from `UIImageView` to
`RWRibbonView`:

    @interface RWViewController ()
        @property (nonatomic, strong) RWRibbonView *imageView;
        @property (nonatomic, strong) RWKnobControl *rotationKnob;
    @end

Replace the first part of the `viewDidLoad` method, which before created the
`UIImageView`, to the following:

    [super viewDidLoad];
    // Create UIImageView
    CGRect frame = self.view.bounds;
    frame.size.height *= 2/3.0;
    self.imageView = [[RWRibbonView alloc] initWithFrame:CGRectInset(frame, 0, 20)];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.imageView.bounds];
    iv.image = [UIImage imageNamed:@"sampleImage.jpg"];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView addSubview:iv];
    [self.view addSubview:self.imageView];

This new code still created a `UIImageView`, but this now exists as a subview
of a `RWRibbonView`.

Build and run the app, and you'll see that you are now using both the
__RWKnobControl__ and the __RWRibbonView__ from the __RWUIControls__ framework.

![ImageViewer with Ribbon](img/image_viewer_with_ribbon.gif)


## Where To Go From Here?

In this tutorial you've learned everything you need to know about how to build
a framework for use in iOS projects, including the best way to develop
frameworks and how to use bundles to share assets. If there is some
functionality that you find yourself using in lots of different apps then maybe
you should think about creating a library make code reuse really easy? A
framework offers an excellent way to collect a library of code together, and
will allow you to drop your library in to any projects you wish.
