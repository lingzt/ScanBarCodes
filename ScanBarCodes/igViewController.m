//
//  igViewController.m
//  ScanBarCodes
//
//  Created by Torrey Betts on 10/10/13.
//  Copyright (c) 2013 Infragistics. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "igViewController.h"
#import "EventViewController.h"


@interface igViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;

    UIView *_highlightView;
    UILabel *_label;
    UIButton *_button;
    NSString *_detectionString;
    
}
@end

@implementation igViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    _detectionString = nil;

    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
//    _highlightView.tag = 12345;
    [self.view addSubview:_highlightView];
    
//    _button = [[UIButton alloc] init];
//    _button.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
//    _button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _button.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.95];
//    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_button setTitle:@"done" forState:UIControlStateNormal];
//    [self.view addSubview:_button];

    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"Please scan your inviation RQ code";
    [self.view addSubview:_label];

    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;

    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }

    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];

    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];

    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];

    [_session startRunning];

    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
//    [self.view bringSubviewToFront:_button];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];

    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                _detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }

        if (_detectionString != nil)
        {
            NSLog(@"%@",_detectionString);
            //Next version retrive QR code information from firebase
//            [[self.view viewWithTag:12345] removeFromSuperview];
            [_session stopRunning];
//            [self performSegueWithIdentifier:@"toEvent" sender:self];
            break;
        }
        else
            NSLog(@"(none)");
    }
    _highlightView.frame = highlightViewRect;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EventViewController *dvc = [segue destinationViewController];
    NSLog(@"__________________________%@",_detectionString);
    [dvc setScannedResult:_detectionString];

}



@end