<?php

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiResource;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * @ApiResource
 * @ORM\Entity
 */
final class Widget {
    /**
     * @ORM\Column(type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @ORM\Column(length=20)
     * @Assert\Length(
     *      max = 20,
     *      maxMessage = "The widget name must contain at most {{ limit }} characters."
     * )
     * @Assert\NotBlank
     * @Assert\NotNull
     */
    private $name;

    /**
     * @ORM\Column(length=100, nullable=true)
     * @Assert\Length(
     *      max = 100,
     *      maxMessage = "The widget description must contain at most {{ limit }} characters."
     * )
     */
    private $description;

    public function getId(): ?int {
        return $this->id;
    }

    public function getName(): string {
        return $this->name;
    }

    public function getDescription(): ?string {
        return $this->description;
    }

    public function setName(string $name) {
        $this->name = $name;
    }

    public function setDescription(?string $description) {
        $this->description = $description;
    }
}
