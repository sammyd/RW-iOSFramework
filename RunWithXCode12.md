There will be some when obstacles compiling the project when using latest version of XCode (2021).

1. error: Multiple commands produce...

Check this: https://stackoverflow.com/a/50815309/9427557

1. fatal error: lipo xxx/libRWUIControls.a and xxx/libRWUIControls.a have the same architectures (arm64) and can't be in the same fat output file

Check this: https://github.com/CocoaPods/cocoapods-packager/issues/259

Xcode -> Project -> Build settings -> Architectures -> Excluded architectures -> + -> Any iOS Simulator SDK -> arm64

1. accessing build database "xxx/RWUIControls-bqcyuotuywxkkjafqvyxggpcxxvj/Build/Intermediates.noindex/XCBuildData/build.db": database is locked Possibly there are two concurrent builds running in the same filesystem location.

Check this: https://stackoverflow.com/questions/51153525/xcode-10-unable-to-attach-db-error

OBJROOT="${OBJROOT}" \ -> OBJROOT="${OBJROOT}/DependantBuilds" \
