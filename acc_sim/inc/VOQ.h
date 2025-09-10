//
// Created by PCG on 2023/5/25.
//

#ifndef ACCELERATOR_VOQ_H
#define ACCELERATOR_VOQ_H

#endif //ACCELERATOR_VOQ_H

#include "Accelerator.h"

using namespace std;

class VirtualQueue {
private:
    int channels;
    vector<vector<int>> queue;

public:
    VirtualQueue(int numChannels, int nums) : channels(numChannels), queue(nums) {}

    void push(int channel, int item) {
        if (channel < 0 || channel >= channels) {
            throw std::out_of_range("Channel index out of range.");
        }
        queue[channel].push_back(item);
    }

    int front() {
        if (empty()) {
            throw std::out_of_range("Queue is empty.");
        }
        for (int channel = 0; channel < channels; ++channel) {
            if (!queue[channel].empty()) {
                int item = queue[channel].front();
                return item;
            }
        }
        return -1;  // Optional: Return a default value if queue is somehow empty
    }

    int pop() {
        if (empty()) {
            throw std::out_of_range("Queue is empty.");
        }
        for (int channel = 0; channel < channels; ++channel) {
            if (!queue[channel].empty()) {
                int item = queue[channel].front();
                queue[channel].erase(queue[channel].begin());
                return item;
            }
        }
        return -1;  // Optional: Return a default value if queue is somehow empty
    }

    bool empty() {
        for (int channel = 0; channel < channels; ++channel) {
            if (!queue[channel].empty()) {
                return false;
            }
        }
        return true;
    }

    int size() const {
        int count = 0;
        for (int channel = 0; channel < channels; ++channel) {
            count += queue[channel].size();
        }
        return count;
    }
};

class Queue {
private:
    std::vector<int> elements;

public:
    Queue(int nums) : elements(nums) {}

    void push(int element) {
        elements.push_back(element);
    }

    int pop() {
        if (elements.empty()) {
            // 队列为空，抛出异常或返回一个特定的值
            throw std::runtime_error("Queue is empty");
        }

        int frontElement = elements.front();
        elements.erase(elements.begin());
        return frontElement;
    }

    int front() {
        if (elements.empty()) {
            // 队列为空，抛出异常或返回一个特定的值
            throw std::runtime_error("Queue is empty");
        }

        return elements.front();
    }

    bool empty() {
        return elements.empty();
    }

    int size() {
        return elements.size();
    }
};