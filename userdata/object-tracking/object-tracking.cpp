
// g++ -g object-tracking.cpp  `pkg-config opencv --cflags --libs`


#include <opencv2/opencv.hpp>
#include <opencv2/tracking/tracking.hpp>



int main(int argc, char *argv[])
{
    cv::VideoCapture vc(argv[1]);
    std::string tracker_name = "KCF";
    if (argc == 3) {
        tracker_name = argv[2];
    }
    bool has_init = false;
    
    cv::Ptr<cv::Tracker> tracker = cv::Tracker::create(tracker_name);
    
    while (1) {
        cv::Mat frame;
        vc >> frame;
        if (frame.empty()) break;
        
        cv::resize(frame, frame, cv::Size(640, 480));
        cv::Rect2d box;
        if (has_init) {
            tracker->update(frame, box);
            cv::rectangle(frame, box, CV_RGB(0, 255, 0), 1);
        }
        cv::imshow("Frame", frame);
        char key = cv::waitKey(1);
        
        if ('s' == key) {
            cv::Rect2d box = cv::selectROI("Frame", frame, true, false);
            std::cout << "select roi " << box << std::endl;
            tracker->init(frame, box);
            has_init = true;
        } else if ('q' == key) {
            break;
        }
    }
    return 0;
}


