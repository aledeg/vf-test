<?php

namespace App\EventSubscriber;

use ApiPlatform\Core\EventListener\EventPriorities;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Event\ResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;

final class DaySubscriber implements EventSubscriberInterface {
    public static function getSubscribedEvents() {
        return [
            KernelEvents::RESPONSE => ['addHeader', EventPriorities::POST_RESPOND],
        ];
    }

    public function addHeader(ResponseEvent $event): void {
        $response = $event->getResponse();
        $response->headers->set('X-Day', (new \DateTime('now'))->format('l'));
    }
}
