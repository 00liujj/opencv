// g++ -g multi-object-tracking.cpp  `pkg-config opencv --cflags --libs`


#include <opencv2/opencv.hpp>
#include <opencv2/tracking/tracking.hpp>



int main(int argc, char *argv[])
{
    cv::VideoCapture vc(argv[1]);
    std::string tracker_name = "KCF";
    if (argc == 3) {
        tracker_name = argv[2];
    }
    
    cv::MultiTracker trackers;
    
    while (1) {
        cv::Mat frame;
        vc >> frame;
        if (frame.empty()) break;
        
        cv::resize(frame, frame, cv::Size(640, 480));
        std::vector<cv::Rect2d> boxes;
        trackers.update(frame, boxes);
        for (int i=0; i<boxes.size(); i++) {
            cv::rectangle(frame, boxes[i], CV_RGB(0, 255, 0), 1);
        }
        cv::imshow("Frame", frame);
        char key = cv::waitKey(1);
        
        if ('s' == key) {
            cv::Rect2d box = cv::selectROI("Frame", frame, true, false);
            std::cout << "select roi " << box << std::endl;
            //tracker = cv::Tracker_create(tracke r_name);
            trackers.add(tracker_name, frame, box);
        } else if ('q' == key) {
            break;
        }
    }
    return 0;
}


