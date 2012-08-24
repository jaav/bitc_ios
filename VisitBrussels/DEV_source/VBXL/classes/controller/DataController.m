//
//  DataController.m
//  VBXL
//
//  Created by Wim Vanhenden on 25/07/11.
//  Copyright 2011 Little Miss Robot. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89	
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "DataController.h"

static DataController *_instance;
@implementation DataController

#pragma mark -
#pragma mark Singleton Methods

+ (DataController*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            
            // Allocate/initialize any member variables of the singleton class here
            // example
			//_instance.member = @"";
            
            
            [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(areWeConnected:) name:@"weareconnected" object:nil];
             [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(xmlfilesAreDownloaded) name:@"doneloadingxmlfilesfrominternet" object:nil];
            
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [super allocWithZone:zone];			
            return _instance;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    [[NSNotificationCenter defaultCenter] removeObserver:_instance];
    return self;	
}

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here


-(NSMutableArray*)checkDataDateStampForCurrentLanguage {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"YYYYMMdd";
    
    NSString *preferredLang = [[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString];
    CategoriesHolder *holder = [CategoriesHolder sharedInstance];
    
    NSMutableArray *categ = [holder.categories.categories objectForKey:preferredLang];
    NSMutableArray *returnvalues = [[NSMutableArray alloc] init];
    
    for (int i=0; i< [categ count]; ++i) {
        Categorie *mycateg = [categ objectAtIndex:i];
            
        NSDate *docdate = [formatter dateFromString:mycateg.exporteddate];
        
        //NSLog(@"Categorie = %@, docdate = %@",mycateg,docdate);
        
        if (![docdate isThisWeek]) {
            NSString *xmlfile = mycateg.group;
            [returnvalues addObject:xmlfile];
        }
    }
    
    [formatter release];
    
    return returnvalues;
}

-(void) checkInterNetConnection {
    Services *service = [Services sharedInstance];
    service.connectedcallback = @"weareconnected";
    [service checkIfConnectedToInternet];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
         NSMutableArray *myaar = [self checkDataDateStampForCurrentLanguage];
         Services *service = [Services sharedInstance];
         [service loadXMLBasedOnLanguage:myaar]; 
         [myaar release];
    } else {
        VBXLNotificationCenter *notif = [VBXLNotificationCenter sharedInstance];
        [notif startApp];
    }
}

NSComparisonResult sortByNumber(id firstItem, id secondItem, void *context) {
    Item *itemone = (Item*)firstItem;
    Item *itemtwo = (Item*)secondItem;
    
    NSNumber *firstint  =  [NSNumber numberWithInt:itemone.positionlist];
    NSNumber *secondint =  [NSNumber numberWithInt:itemtwo.positionlist];
   
    return [secondint compare:firstint];
}


-(NSMutableArray*) returnItemsBasedOnGroup:(NSString*)group {
    CategoriesHolder *holder = [CategoriesHolder sharedInstance];
    
    NSString *preferredLang = [[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString];
    
    for (int i=0; i< [[holder.categories.categories objectForKey:preferredLang] count]; ++i) {
        Categorie *mycata = [[holder.categories.categories objectForKey:preferredLang] objectAtIndex:i];
        if ([mycata.group isEqualToString:group]) {
            
            [mycata.items sortUsingFunction:sortByNumber context:@"sortitems"];
            
            return mycata.items;
        }
    }
    return nil;
}

- (NSMutableArray *) returnItemsBasedOnNavigationItem:(NSString*)navitem {

    AppData *data = [AppData sharedInstance];
    
    for (int i=0; i<[data.navigationtree count]; i++) {
        NSString *string = [[data.navigationtree objectAtIndex:i] objectAtIndex:1];
        if ([string isEqualToString:navitem]) {
            NSString *group = [[data.navigationtree objectAtIndex:i] objectAtIndex:0];
            return [self returnItemsBasedOnGroup:group];
        }
    }
    return nil;
}


-(NSMutableArray*) getALLXMLFilesForCurrentLanguage {
    
    AppData *data = [AppData sharedInstance];
    
    NSMutableArray *returnvalue = [[NSMutableArray alloc]init];
    
    NSString *preferredLang = [[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString];
    
    if (![preferredLang isEqualToString:@"EN"] && ![preferredLang isEqualToString:@"NL"] && ![preferredLang isEqualToString:@"FR"]) {
        preferredLang = @"EN";
    }
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:data.rootpathfordownloadedxmls error:nil];
    
    for (NSString *file in files) {
        NSString * subsr = [file substringWithRange:NSMakeRange([file length]-6, 2)];
        
        if ([subsr isEqualToString:preferredLang]) {
            [returnvalue addObject:file];
        }
    }
    
    return returnvalue;
}

- (Categorie *) parseXML:(TBXMLElement*)root {
    
    Categorie *newcat = [[Categorie alloc] init];
    
    //SET GROUP
    TBXMLElement * group = [TBXML childElementNamed:@"group" parentElement:root];    
    if (group) {
        newcat.group = [TBXML textForElement:group];
    }
    
    //SET LANGUAGE
    TBXMLElement * language = [TBXML childElementNamed:@"language" parentElement:root];
    if (language) {
        newcat.language = [TBXML textForElement:language];
    }
    
    //SET DATE
    TBXMLElement * date = [TBXML childElementNamed:@"exported_date" parentElement:root];
    if (date) {
        newcat.exporteddate = [TBXML textForElement:date];
        //newcat.exporteddate = @"20120824";
    }
    
    //LOOP THROUGH THE ITEMS
    TBXMLElement * items = [TBXML childElementNamed:@"items" parentElement:root];
    if (items) {
        TBXMLElement * item = [TBXML childElementNamed:@"item" parentElement:items];
        while (item) {
            Item *myitem = [Item alloc];
            
            myitem.parentgroup = [TBXML textForElement:group];
            
            NSString *_id = [TBXML valueOfAttributeNamed:@"id" forElement:item];
            myitem.id_item = [_id integerValue];
            myitem.title = [TBXML textForElement:[TBXML childElementNamed:@"title" parentElement:item]];
            
            //set image properties
            NSString *imageurl = [TBXML textForElement:[TBXML childElementNamed:@"small_image" parentElement:item]];
            NSURL *url = [NSURL URLWithString: [imageurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
            myitem.smallimage = imageurl;
            myitem.imagefilename = [url lastPathComponent];
            
            TBXMLElement * bigImageElement = [TBXML childElementNamed:@"big_image" parentElement:item];
            
            if(bigImageElement){
                NSString *bigimageurl = [TBXML textForElement:bigImageElement];
                NSURL *bigurl = [NSURL URLWithString: [bigimageurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
                myitem.bigimage = bigimageurl;
                myitem.bigimagefilename = [bigurl lastPathComponent];
            }
            //end image properties
            
            myitem.body = [TBXML textForElement:[TBXML childElementNamed:@"body" parentElement:item]];
            
            if ([TBXML childElementNamed:@"address" parentElement:item]) {
                myitem.address = [TBXML textForElement:[TBXML childElementNamed:@"address" parentElement:item]];
            }
            if ([TBXML childElementNamed:@"city" parentElement:item]) {
                myitem.city = [TBXML textForElement:[TBXML childElementNamed:@"city" parentElement:item]];
            }
            if ([TBXML childElementNamed:@"zipcode" parentElement:item]) {
                NSString *zipcode = [TBXML textForElement:[TBXML childElementNamed:@"zipcode" parentElement:item]];            
                myitem.zipcode = [zipcode integerValue];
            }
            if ([TBXML childElementNamed:@"phone" parentElement:item]) {
                 myitem.phone = [TBXML textForElement:[TBXML childElementNamed:@"phone" parentElement:item]];
            }
            if ([TBXML childElementNamed:@"fax" parentElement:item]) {
                myitem.fax = [TBXML textForElement:[TBXML childElementNamed:@"fax" parentElement:item]];
            }
            if ([TBXML childElementNamed:@"email" parentElement:item]) {
                myitem.email = [TBXML textForElement:[TBXML childElementNamed:@"email" parentElement:item]];
            }
            if ([TBXML childElementNamed:@"website" parentElement:item]) {
                myitem.website = [TBXML textForElement:[TBXML childElementNamed:@"website" parentElement:item]];
            }
            if ([TBXML childElementNamed:@"latitude" parentElement:item]) {
                NSString *latitude = [TBXML textForElement:[TBXML childElementNamed:@"latitude" parentElement:item]];
                myitem.latitude = [NSDecimalNumber decimalNumberWithString:latitude];
            }
            if ([TBXML childElementNamed:@"longitude" parentElement:item]) {
                 NSString *longitude = [TBXML textForElement:[TBXML childElementNamed:@"longitude" parentElement:item]];
                 myitem.longitude = [NSDecimalNumber decimalNumberWithString:longitude];
            }
            if ([TBXML childElementNamed:@"position" parentElement:item]) {
                NSString *position = [TBXML textForElement:[TBXML childElementNamed:@"position" parentElement:item]];
                myitem.positionlist = [position integerValue];
            }
        
            if ([TBXML childElementNamed:@"price" parentElement:item]) {
                
                NSString *price = [TBXML textForElement:[TBXML childElementNamed:@"price" parentElement:item]];
                myitem.price = price;
            }
            
            if ([TBXML childElementNamed:@"ranking" parentElement:item]) {
                NSString *ranking = [TBXML textForElement:[TBXML childElementNamed:@"ranking" parentElement:item]];
                myitem.ranking = [ranking integerValue];
            }
            
            if ([TBXML childElementNamed:@"period_from_date" parentElement:item]) {
                myitem.fromdate = [TBXML textForElement:[TBXML childElementNamed:@"period_from_date" parentElement:item]];
            }
            
            if ([TBXML childElementNamed:@"period_to_date" parentElement:item]) {
                myitem.todate = [TBXML textForElement:[TBXML childElementNamed:@"period_to_date" parentElement:item]];
            }
            if ([TBXML childElementNamed:@"period_to_date" parentElement:item]) {
                myitem.todate = [TBXML textForElement:[TBXML childElementNamed:@"period_to_date" parentElement:item]];
            }
            
            if ([TBXML childElementNamed:@"cuisines" parentElement:item]) {
                
                TBXMLElement *thisitem =  [TBXML childElementNamed:@"cuisines" parentElement:item];
                
                NSMutableArray *cuisines = [[NSMutableArray alloc] init];
                
                if (thisitem->firstChild) {
                
                    TBXMLElement *childs = thisitem->firstChild;
                    do {
                        [cuisines addObject:[TBXML textForElement:childs]];
                        childs = childs->nextSibling;
                    } while (childs);
                        
                }
                
                myitem.cuisines = [NSMutableArray arrayWithArray:cuisines];
                
                [cuisines release];
            
            }
            
            //NSLog(@"item %@",[myitem title]);
            
            [newcat.items addObject:myitem];
            [myitem release];
            
            item = [TBXML nextSiblingNamed:@"item" searchFromElement:item];
        }
    }
    return newcat;   
}   

-(NSMutableArray*) parseXMLSForCurrentLanguage {
    
    AppData *data = [AppData sharedInstance];
    NSMutableArray *xmlstoparse = [self getALLXMLFilesForCurrentLanguage];
    
    NSMutableArray * categories = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[xmlstoparse count]; i++) {
        
         
        NSString *xmldoc = [NSString stringWithFormat:@"%@/%@",data.rootpathfordownloadedxmls, [xmlstoparse objectAtIndex:i]];
        
        NSURL *url = [NSURL fileURLWithPath:xmldoc];
        
        TBXML *tbxml =[TBXML tbxmlWithURL:url];
        
        TBXMLElement *root = tbxml.rootXMLElement;
        
        if (root) {
            Categorie *inccatmycat = [self parseXML:root];
          
            [categories addObject:inccatmycat];
            [inccatmycat release];
        }
    }
    [xmlstoparse release];
    return categories;
}


- (void) removeParsedXMLsForCurrentLanguage {
    NSLog(@"remove used xml's");
    AppData *data = [AppData sharedInstance];
    NSMutableArray * xmlfiles= [self getALLXMLFilesForCurrentLanguage];
    for (NSString *file in xmlfiles) {
        NSString *filepath  = [NSString stringWithFormat:@"%@/%@",data.rootpathfordownloadedxmls,file];
        NSURL *url = [NSURL fileURLWithPath:filepath];
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    }
    [xmlfiles release];
}


- (void) encryptDataAndWriteToDisk {
    NSLog(@"encrypt data and write to disk");
    BOOL isDirectory;
    AppData *data = [AppData sharedInstance];
    if ([[NSFileManager defaultManager] fileExistsAtPath:data.rootpathforencryptedata isDirectory:&isDirectory] && isDirectory) {
    } else {
        //Create it
        [[NSFileManager defaultManager] createDirectoryAtPath:data.rootpathforencryptedata withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *datapath = [data.rootpathforencryptedata stringByAppendingPathComponent:@"encr.data"];

    CategoriesHolder *categoriesholder = [CategoriesHolder sharedInstance];
    
    [NSKeyedArchiver archiveRootObject:categoriesholder.categories toFile:datapath];
    
}

-(void)moveTheXMLFilesToDocumentDirectory {
    BOOL isDirectory;
    AppData *data = [AppData sharedInstance];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:data.rootpathfordownloadedxmls isDirectory:&isDirectory] && isDirectory) {
        NSLog(@"check for xml directory --> xml directory already exists, %@", data.rootpathfordownloadedxmls);
    } else {
        //Directory did not exists
        //Create it
        [[NSFileManager defaultManager] createDirectoryAtPath:data.rootpathfordownloadedxmls withIntermediateDirectories:YES attributes:nil error:nil];
        
        //Move the XML files
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:data.rootpathforinitialdata error:nil];
        NSLog(@"check for xml directory --> did not exist --> move the files");
        if ([files count]>0) {
            for (NSString *file in files) {
                if ([file.pathExtension compare:@"xml" options:NSCaseInsensitiveSearch] == NSOrderedSame) { 
                    NSString *incomingfile = [data.rootpathforinitialdata stringByAppendingPathComponent:file];
                    NSString *outgoingfile = [data.rootpathfordownloadedxmls stringByAppendingPathComponent:file];
                    [[NSFileManager defaultManager] copyItemAtPath:incomingfile toPath:outgoingfile error:nil];
                }
            }
        }
    }
}

-(BOOL) persistData {
    AppData *data = [AppData sharedInstance];
    NSString *datapath = [data.rootpathforencryptedata stringByAppendingPathComponent:@"encr.data"];
        //NSLog(@"persist data = %@", datapath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:datapath]) {
            NSLog(@"persist data is found --> start to unarchive");
            CategoriesHolder *holder = [CategoriesHolder sharedInstance];
            holder.categories = [NSKeyedUnarchiver unarchiveObjectWithFile:datapath];
            return true;
    } else {
        NSLog(@"no local data found");
    }
    
    return  false;
}

- (void) checkForOutdatedFiles {
    NSMutableArray *myaar = [self checkDataDateStampForCurrentLanguage];
    if ([myaar count]>0) {
         NSLog(@"check for outdated files --> outdated files found");
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AVTITLE", nil) message:NSLocalizedString(@"AVMESSAGE", nil) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
         alert.delegate = self;
         [alert show];
         [alert release];
     } else {
          NSLog(@"check for outdated files --> no outdated files found --> start app");
         VBXLNotificationCenter *notif = [VBXLNotificationCenter sharedInstance];
         [notif startApp];
     }
     [myaar release];
}


-(void) areWeConnected:(NSNotification*)notif {
   
    if ([notif.object isEqualToString:@"YES"]) {
         NSLog(@"connected to internet? --> %@ --> check for outdated files",notif.object);
        [self checkForOutdatedFiles];
    } else {
        NSLog(@"connected to internet? --> %@ --> start app",notif.object);
        VBXLNotificationCenter *notif = [VBXLNotificationCenter sharedInstance];
        [notif startApp];
    }
}


-(void) fillVOSWithCategories:(NSMutableArray*)incmut {
    NSString *preferredLang = [[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString];
    CategoriesHolder *holder = [CategoriesHolder sharedInstance];
    
    if ([holder.categories.categories objectForKey:preferredLang]) {
        NSLog(@"filling vo's for existing language");
        for (int i=0; i<[incmut count]; i++) {
            Categorie *mycat = [incmut objectAtIndex:i];
            [holder replaceCategorie:mycat forGroup:mycat.group];
        }
    } else {
         NSLog(@"filling vo's for new language");
        [holder.categories.categories setObject:incmut forKey:[preferredLang uppercaseString]];
    }
}


-(void) startParsingSequence {

    NSMutableArray *categoperies = [self parseXMLSForCurrentLanguage];
    
    if ([categoperies count]>0) {
        NSLog(@"we have xmls to parse --> start parsing sequence");
        [self fillVOSWithCategories:categoperies];
        [self encryptDataAndWriteToDisk];
        [self removeParsedXMLsForCurrentLanguage];
    } else {
        NSLog(@"no xml to parse --> end parsing sequence");
    }
    [categoperies release];
}

-(void) xmlfilesAreDownloaded {
    NSLog(@"xml files are downloaded");
    [self startParsingSequence];
    NSLog(@"start app");
    VBXLNotificationCenter *notif = [VBXLNotificationCenter sharedInstance];
    [notif startApp];
}


-(void) controlDataStartUp {
    NSLog(@"startup commenced");
    [self moveTheXMLFilesToDocumentDirectory];
    [self persistData];
    [self startParsingSequence];
    [self checkInterNetConnection];
}

-(NSMutableArray*) returnAllItems {
    NSMutableArray *returnarray = [[[NSMutableArray alloc] init ] autorelease];
    CategoriesHolder *holder = [CategoriesHolder sharedInstance];
    NSString *preferredLang = [[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString];
    
    for (int i=0; i< [[holder.categories.categories objectForKey:preferredLang] count]; ++i) {
        Categorie *mycata = [[holder.categories.categories objectForKey:preferredLang] objectAtIndex:i];
        for (int j=0; j<[mycata.items count]; j++) {
            Item *myitem = [mycata.items objectAtIndex:j];
            [returnarray addObject:myitem];
        }
    }
    return returnarray;
}

+(NSString *)adjustedNibName:(NSString *)nib{
    return isPad?[nib stringByAppendingString:@"_iPad"]:nib;
}

+(NSString *)adjustedImageName:(NSString *)imageName{
    if(isPad)
        return [NSString stringWithFormat:@"%@_iPad.%@",[imageName stringByDeletingPathExtension],[imageName pathExtension]];
    return imageName;
}

@end
